#!/usr/bin/env bash
# NexaShield Abuse IP - installateur Linux / Linux installer
# Bloque les IP malveillantes publiées par NexaShield, met la liste à jour toutes les heures
# et ouvre votre tableau de bord local : ce que NexaShield bloque chez vous, en direct.
# Blocks the malicious IPs published by NexaShield, refreshes the list every hour
# and gives you a local dashboard of what NexaShield blocks on this machine.
#
#   Installer / install         : sudo bash install.sh
#   Tableau de bord / dashboard : http://127.0.0.1:8787  (à distance : ssh -L 8787:127.0.0.1:8787 <serveur>)
#   Mettre à jour / update      : sudo nexashield-blocklist update
#   État / status               : sudo nexashield-blocklist status
#   Désinstaller / uninstall    : sudo bash install.sh --uninstall
#
# Moteur : nftables si présent, sinon ipset + iptables/ip6tables. Tableau de bord : python3 requis.
# Liste d'exceptions : /etc/nexashield/allowlist.txt (une IP par ligne, jamais bloquée).
# https://github.com/bastivanconsulting/Nexashield-Abuse-IP · NexaShield EDR · XDR · NDR · MDR · Bastivan Consulting
set -euo pipefail

BIN=/usr/local/sbin/nexashield-blocklist
LIB=/usr/local/lib/nexashield
VAR=/var/lib/nexashield
CONF=/etc/nexashield
RAW=https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main
PORT="${NEXASHIELD_DASHBOARD_PORT:-8787}"
UNITS="nexashield-blocklist.service nexashield-blocklist.timer nexashield-collect.service nexashield-collect.timer nexashield-dashboard.service"

[ "$(id -u)" -eq 0 ] || { echo "À lancer en root (sudo) / run as root" >&2; exit 1; }

uninstall() {
    for u in nexashield-blocklist.timer nexashield-collect.timer nexashield-dashboard.service; do systemctl disable --now "$u" 2>/dev/null || true; done
    for u in $UNITS; do rm -f "/etc/systemd/system/$u"; done
    rm -f /etc/cron.d/nexashield-blocklist
    systemctl daemon-reload 2>/dev/null || true
    if command -v nft >/dev/null; then nft delete table inet nexashield 2>/dev/null || true; fi
    for t in iptables ip6tables; do
        command -v $t >/dev/null || continue
        while $t -D INPUT -j NEXASHIELD 2>/dev/null; do :; done
        while $t -D OUTPUT -j NEXASHIELD 2>/dev/null; do :; done
        while $t -D FORWARD -j NEXASHIELD 2>/dev/null; do :; done
        $t -F NEXASHIELD 2>/dev/null || true; $t -X NEXASHIELD 2>/dev/null || true
    done
    if command -v ipset >/dev/null; then for s in nexashield-v4 nexashield-v6; do ipset destroy $s 2>/dev/null || true; done; fi
    rm -rf "$BIN" "$LIB" "$VAR"
    echo "NexaShield : désinstallé (la liste d'exceptions $CONF est conservée) / uninstalled"
}
[ "${1:-}" = "--uninstall" ] && { uninstall; exit 0; }

command -v curl >/dev/null || { echo "curl requis / curl is required" >&2; exit 1; }
if ! command -v nft >/dev/null && ! { command -v ipset >/dev/null && command -v iptables >/dev/null; }; then
    echo "nftables ou ipset+iptables requis / nftables or ipset+iptables required" >&2; exit 1
fi
HAS_PY=0; command -v python3 >/dev/null && HAS_PY=1

mkdir -p "$CONF" "$LIB" "$VAR/www/data"
chmod 755 "$VAR" "$VAR/www" "$VAR/www/data"
[ -f "$CONF/allowlist.txt" ] || printf '# Une IP par ligne : jamais bloquée par NexaShield / one IP per line, never blocked\n' > "$CONF/allowlist.txt"

# ---------------------------------------------------------------- collecteur (compteurs par IP)
cat > "$LIB/collect.py" <<'EOF'
#!/usr/bin/env python3
"""NexaShield : relève les compteurs par IP du pare-feu et alimente le tableau de bord local.
Aucune donnée ne quitte la machine. Usage : collect.py [--baseline] [--list N4 N6 ENGINE]"""
import datetime, json, os, re, shutil, subprocess, sys, tempfile

VAR = "/var/lib/nexashield"
STATE, OUT = f"{VAR}/state.json", f"{VAR}/www/data/status.json"
now = datetime.datetime.now(datetime.timezone.utc)
ts = now.strftime("%Y-%m-%dT%H:%M:%SZ")


def run(*cmd):
    try:
        return subprocess.run(cmd, capture_output=True, text=True, timeout=30).stdout
    except (OSError, subprocess.SubprocessError):
        return ""


def counters():
    c, engine = {}, None
    if shutil.which("nft") and run("nft", "list", "table", "inet", "nexashield"):
        engine = "nftables"
        for s in ("v4", "v6"):
            for m in re.finditer(r"([0-9A-Fa-f:.]+) counter packets (\d+) bytes (\d+)", run("nft", "list", "set", "inet", "nexashield", s)):
                c[m.group(1).lower()] = (int(m.group(2)), int(m.group(3)))
    elif shutil.which("ipset"):
        engine = "ipset"
        for s in ("nexashield-v4", "nexashield-v6"):
            for m in re.finditer(r"^add \S+ (\S+) packets (\d+) bytes (\d+)", run("ipset", "list", s, "-o", "save"), re.M):
                c[m.group(1).lower()] = (int(m.group(2)), int(m.group(3)))
    return c, engine


def write(path, obj):
    fd, tmp = tempfile.mkstemp(dir=os.path.dirname(path))
    with os.fdopen(fd, "w") as f:
        json.dump(obj, f, separators=(",", ":"))
    os.chmod(tmp, 0o644 if path == OUT else 0o600)
    os.replace(tmp, path)


try:
    st = json.load(open(STATE))
except (OSError, ValueError):
    st = {}
st.setdefault("installed", ts); st.setdefault("ips", {}); st.setdefault("daily", {}); st.setdefault("hourly", {}); st.setdefault("list", {})
args = sys.argv[1:]
if "--list" in args:
    i = args.index("--list")
    st["list"] = {"v4": int(args[i + 1]), "v6": int(args[i + 2]), "engine": args[i + 3], "updated": ts}

cur, engine = counters()
day, hour = ts[:10], ts[:13]
for ip, (p, b) in cur.items():
    e = st["ips"].setdefault(ip, {"lp": 0, "lb": 0, "p": 0, "b": 0})
    dp = p - e["lp"] if p >= e["lp"] else p          # compteurs remis à zéro lors d'une mise à jour de la liste
    db = b - e["lb"] if b >= e["lb"] else b
    if "--baseline" not in args and dp > 0:
        e["p"] += dp; e["b"] += db; e.setdefault("first", ts); e["last"] = ts
        st["daily"][day] = st["daily"].get(day, 0) + dp
        st["hourly"][hour] = st["hourly"].get(hour, 0) + dp
    e["lp"], e["lb"] = p, b
for ip in [k for k, v in st["ips"].items() if k not in cur and not v["p"]]:
    del st["ips"][ip]                                 # IP retirée de la liste et jamais vue : inutile de la garder
st["daily"] = dict(sorted(st["daily"].items())[-90:])
st["hourly"] = dict(sorted(st["hourly"].items())[-48:])
st["collected"] = ts
write(STATE, st)

hit = {k: v for k, v in st["ips"].items() if v["p"]}
top = sorted(hit.items(), key=lambda kv: -kv[1]["p"])[:300]
write(OUT, {
    "generated": ts, "installed": st["installed"], "engine": engine or st["list"].get("engine"), "active": bool(cur),
    "list": st["list"], "host": os.uname().nodename,
    "totals": {"packets": sum(v["p"] for v in hit.values()), "bytes": sum(v["b"] for v in hit.values()), "attackers": len(hit),
               "today": st["daily"].get(day, 0)},
    "top": [{"ip": k, "packets": v["p"], "bytes": v["b"], "first": v.get("first"), "last": v.get("last")} for k, v in top],
    "daily": st["daily"], "hourly": st["hourly"],
})
EOF
chmod 755 "$LIB/collect.py"

# ---------------------------------------------------------------- mise à jour du blocage
cat > "$BIN" <<'EOF'
#!/usr/bin/env bash
# NexaShield Abuse IP - mise à jour du blocage / blocklist update
set -euo pipefail
RAW="${NEXASHIELD_RAW:-https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main}"
ALLOW=/etc/nexashield/allowlist.txt
LIB=/usr/local/lib/nexashield
WWW=/var/lib/nexashield/www
MIN=10            # garde-fou : une liste anormalement courte n'est jamais appliquée / never apply a truncated list
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT
collect() { if command -v python3 >/dev/null && [ -x "$LIB/collect.py" ]; then python3 "$LIB/collect.py" "$@" || true; fi; }

status() {
    if command -v nft >/dev/null && nft list table inet nexashield >/dev/null 2>&1; then
        echo "moteur / engine : nftables"
        echo "IPv4 : $(nft list set inet nexashield v4 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+ counter' | wc -l)"
        echo "IPv6 : $(nft list set inet nexashield v6 | grep -oE '[0-9a-f:]+:[0-9a-f:]* counter' | wc -l)"
        nft list chain inet nexashield input | grep counter
    elif command -v ipset >/dev/null && ipset list -n 2>/dev/null | grep -q nexashield-v4; then
        echo "moteur / engine : ipset"; ipset list nexashield-v4 | grep -m1 'Number of entries' || true
    else echo "non actif / not active"; fi
    [ -f "$WWW/data/status.json" ] && echo "tableau de bord / dashboard : http://127.0.0.1:${NEXASHIELD_DASHBOARD_PORT:-8787}"
}
case "${1:-update}" in
    status) status; exit 0 ;;
    collect) collect; exit 0 ;;
esac

curl -fsS --proto =https --tlsv1.2 --max-time 60 --retry 3 -o "$TMP/raw" "$RAW/lists/plain/all.txt"
grep -vxF -f <(grep -v '^#' "$ALLOW" 2>/dev/null | tr -d ' \r' | grep . || echo none) "$TMP/raw" > "$TMP/f" || true
grep -E '^([0-9]{1,3}\.){3}[0-9]{1,3}$' "$TMP/f" | sort -u > "$TMP/v4" || true
grep -E '^[0-9A-Fa-f:]+:[0-9A-Fa-f:]*$' "$TMP/f" | tr 'A-F' 'a-f' | sort -u > "$TMP/v6" || true
N4=$(wc -l < "$TMP/v4"); N6=$(wc -l < "$TMP/v6")
[ $((N4 + N6)) -ge $MIN ] || { echo "liste trop courte ($((N4 + N6))) : rien appliqué / list too short, nothing applied" >&2; exit 1; }

collect                                         # relève les compteurs avant de les remettre à zéro
if command -v nft >/dev/null; then
    ENGINE=nftables
    els() { paste -sd, "$1"; }
    {
        echo "table inet nexashield"
        echo "delete table inet nexashield"
        echo "table inet nexashield {"
        echo "  set v4 { type ipv4_addr; counter; $( [ "$N4" -gt 0 ] && echo "elements = { $(els "$TMP/v4") };" ) }"
        echo "  set v6 { type ipv6_addr; counter; $( [ "$N6" -gt 0 ] && echo "elements = { $(els "$TMP/v6") };" ) }"
        echo "  chain input  { type filter hook input priority -10; policy accept; ip saddr @v4 counter drop; ip6 saddr @v6 counter drop; }"
        echo "  chain forward { type filter hook forward priority -10; policy accept; ip saddr @v4 counter drop; ip6 saddr @v6 counter drop; }"
        echo "  chain output { type filter hook output priority -10; policy accept; ip daddr @v4 counter drop; ip6 daddr @v6 counter drop; }"
        echo "}"
    } > "$TMP/rules.nft"
    nft -f "$TMP/rules.nft"                     # remplacement atomique / atomic swap
else
    ENGINE=ipset
    for v in 4 6; do
        fam=inet; [ $v = 6 ] && fam=inet6
        ipset create nexashield-v$v hash:ip family $fam counters -exist
        ipset create nexashield-v$v-new hash:ip family $fam counters -exist
        ipset flush nexashield-v$v-new
        sed "s/^/add nexashield-v$v-new /" "$TMP/v$v" | ipset restore -exist
        ipset swap nexashield-v$v-new nexashield-v$v
        ipset destroy nexashield-v$v-new
        t=iptables; [ $v = 6 ] && t=ip6tables
        command -v $t >/dev/null || continue
        $t -N NEXASHIELD 2>/dev/null || true
        $t -F NEXASHIELD
        $t -A NEXASHIELD -m set --match-set nexashield-v$v src -j DROP
        $t -A NEXASHIELD -m set --match-set nexashield-v$v dst -j DROP
        $t -C INPUT -j NEXASHIELD 2>/dev/null || $t -I INPUT 1 -j NEXASHIELD
        $t -C FORWARD -j NEXASHIELD 2>/dev/null || $t -I FORWARD 1 -j NEXASHIELD
        $t -C OUTPUT -j NEXASHIELD 2>/dev/null || $t -I OUTPUT 1 -j NEXASHIELD
    done
fi
collect --baseline --list "$N4" "$N6" "$ENGINE"   # nouveaux compteurs : point de départ

# Données d'enrichissement du tableau de bord (pays, réseau, nature) : best effort, jamais bloquant
if [ -d "$WWW/data" ]; then
    for f in lists/abuse-ip.json analysis/latest.md analysis/meta.json; do
        curl -fsS --proto =https --tlsv1.2 --max-time 60 -o "$TMP/dl" "$RAW/$f" && install -m 644 "$TMP/dl" "$WWW/data/$(basename "$f")" || true
    done
fi
logger -t nexashield "blocklist: $N4 IPv4, $N6 IPv6" 2>/dev/null || true
echo "NexaShield : $N4 IPv4 + $N6 IPv6 bloquées / blocked"
EOF
chmod 755 "$BIN"

# ---------------------------------------------------------------- fichiers du tableau de bord
DASH=0
if [ "$HAS_PY" = 1 ]; then
    DASH=1
    mkdir -p "$VAR/www/vendor"; chmod 755 "$VAR/www/vendor"
    for f in index.html dashboard.css dashboard.js vendor/chart-4.6.1.umd.min.js vendor/jsvectormap-1.7.0.min.js \
             vendor/jsvectormap-1.7.0.min.css vendor/jsvectormap-1.7.0-world.js vendor/LICENSES.txt; do
        curl -fsS --proto =https --tlsv1.2 --max-time 60 --retry 3 -o "$VAR/www/$f" "$RAW/dashboard/$f" || { DASH=0; break; }
        chmod 644 "$VAR/www/$f"
    done
fi

# ---------------------------------------------------------------- planification
if command -v systemctl >/dev/null && [ -d /run/systemd/system ]; then
    cat > /etc/systemd/system/nexashield-blocklist.service <<EOF
[Unit]
Description=NexaShield Abuse IP blocklist update
Wants=network-online.target
After=network-online.target

[Service]
Type=oneshot
ExecStart=$BIN update
EOF
    cat > /etc/systemd/system/nexashield-blocklist.timer <<'EOF'
[Unit]
Description=NexaShield Abuse IP blocklist hourly update

[Timer]
OnBootSec=2min
OnUnitActiveSec=1h
RandomizedDelaySec=10min
Persistent=true

[Install]
WantedBy=timers.target
EOF
    cat > /etc/systemd/system/nexashield-collect.service <<EOF
[Unit]
Description=NexaShield Abuse IP counters for the local dashboard

[Service]
Type=oneshot
ExecStart=$BIN collect
EOF
    cat > /etc/systemd/system/nexashield-collect.timer <<'EOF'
[Unit]
Description=NexaShield Abuse IP counters every 5 minutes

[Timer]
OnBootSec=3min
OnUnitActiveSec=5min

[Install]
WantedBy=timers.target
EOF
    # Serveur web en lecture seule, utilisateur éphémère sans droits, écoute locale uniquement
    cat > /etc/systemd/system/nexashield-dashboard.service <<EOF
[Unit]
Description=NexaShield Abuse IP local dashboard (127.0.0.1:$PORT)
After=network.target

[Service]
ExecStart=/usr/bin/env python3 -m http.server $PORT --bind 127.0.0.1 --directory $VAR/www
DynamicUser=yes
ProtectSystem=strict
ProtectHome=yes
PrivateTmp=yes
PrivateDevices=yes
NoNewPrivileges=yes
ReadOnlyPaths=$VAR/www
CapabilityBoundingSet=
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX
MemoryMax=128M
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    systemctl enable --now nexashield-blocklist.timer >/dev/null
    if [ "$DASH" = 1 ]; then
        systemctl enable --now nexashield-collect.timer >/dev/null
        systemctl enable --now nexashield-dashboard.service >/dev/null
    fi
    PLAN="timer systemd (toutes les heures / hourly)"
else
    {
        echo "$((RANDOM % 60)) * * * * root $BIN update >/dev/null 2>&1"
        echo "@reboot root sleep 120 && $BIN update >/dev/null 2>&1"
        [ "$DASH" = 1 ] && echo "*/5 * * * * root $BIN collect >/dev/null 2>&1"
    } > /etc/cron.d/nexashield-blocklist
    PLAN="cron (toutes les heures / hourly)"
fi

"$BIN" update
if [ "$DASH" = 1 ] && [ -d /run/systemd/system ]; then
    DASHLINE="Tableau de bord        : http://127.0.0.1:$PORT  (à distance : ssh -L $PORT:127.0.0.1:$PORT <ce-serveur>)"
elif [ "$DASH" = 1 ]; then
    DASHLINE="Tableau de bord        : python3 -m http.server $PORT --bind 127.0.0.1 --directory $VAR/www"
else
    DASHLINE="Tableau de bord        : installez python3 puis relancez l'installateur"
fi
cat <<EOF

  🛡️  NexaShield Abuse IP est actif / is active.
      $DASHLINE
      Mise à jour automatique : $PLAN
      Exceptions / allowlist : $CONF/allowlist.txt
      État / status          : sudo nexashield-blocklist status
      Désinstaller           : sudo bash install.sh --uninstall

  Cette liste bloque les attaquants déjà vus par notre SOC. Pour détecter et stopper
  ceux qui visent vos propres machines (EDR · XDR · NDR · MDR) : contact@bastivan.com
EOF
