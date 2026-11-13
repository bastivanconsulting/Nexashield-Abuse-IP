#!/usr/bin/env bash
# NexaShield Abuse IP - installateur Linux / Linux installer
# Bloque les IP malveillantes publiées par NexaShield et met la liste à jour toutes les heures (timer systemd ou cron).
# Blocks the malicious IPs published by NexaShield and refreshes the list every hour (systemd timer or cron).
#
#   Installer / install      : sudo bash install.sh
#   Mettre à jour / update   : sudo nexashield-blocklist update
#   État / status            : sudo nexashield-blocklist status
#   Désinstaller / uninstall : sudo bash install.sh --uninstall
#
# Moteur : nftables si présent, sinon ipset + iptables/ip6tables.
# Liste d'exceptions : /etc/nexashield/allowlist.txt (une IP par ligne, jamais bloquée).
# https://github.com/bastivanconsulting/Nexashield-Abuse-IP - NexaShield EDR · XDR · NDR · MDR - Bastivan Consulting
set -euo pipefail

BIN=/usr/local/sbin/nexashield-blocklist
CONF=/etc/nexashield

[ "$(id -u)" -eq 0 ] || { echo "À lancer en root (sudo) / run as root" >&2; exit 1; }

uninstall() {
    systemctl disable --now nexashield-blocklist.timer 2>/dev/null || true
    rm -f /etc/systemd/system/nexashield-blocklist.service /etc/systemd/system/nexashield-blocklist.timer /etc/cron.d/nexashield-blocklist
    systemctl daemon-reload 2>/dev/null || true
    if command -v nft >/dev/null; then nft delete table inet nexashield 2>/dev/null || true; fi
    for t in iptables ip6tables; do
        command -v $t >/dev/null || continue
        while $t -D INPUT -j NEXASHIELD 2>/dev/null; do :; done
        while $t -D OUTPUT -j NEXASHIELD 2>/dev/null; do :; done
        $t -F NEXASHIELD 2>/dev/null || true; $t -X NEXASHIELD 2>/dev/null || true
    done
    if command -v ipset >/dev/null; then for s in nexashield-v4 nexashield-v6; do ipset destroy $s 2>/dev/null || true; done; fi
    rm -f "$BIN"
    echo "NexaShield : désinstallé (la liste d'exceptions $CONF est conservée) / uninstalled"
}
[ "${1:-}" = "--uninstall" ] && { uninstall; exit 0; }

command -v curl >/dev/null || { echo "curl requis / curl is required" >&2; exit 1; }
if ! command -v nft >/dev/null && ! { command -v ipset >/dev/null && command -v iptables >/dev/null; }; then
    echo "nftables ou ipset+iptables requis / nftables or ipset+iptables required" >&2; exit 1
fi

mkdir -p "$CONF"
[ -f "$CONF/allowlist.txt" ] || printf '# Une IP par ligne : jamais bloquée par NexaShield / one IP per line, never blocked\n' > "$CONF/allowlist.txt"

cat > "$BIN" <<'EOF'
#!/usr/bin/env bash
# NexaShield Abuse IP - mise à jour du blocage / blocklist update
set -euo pipefail
URL="${NEXASHIELD_URL:-https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/lists/plain/all.txt}"
ALLOW=/etc/nexashield/allowlist.txt
MIN=10            # garde-fou : une liste anormalement courte n'est jamais appliquée / never apply a truncated list
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT

status() {
    if command -v nft >/dev/null && nft list table inet nexashield >/dev/null 2>&1; then
        echo "moteur / engine : nftables"
        echo "IPv4 : $(nft list set inet nexashield v4 | tr ',{}' '\n\n\n' | grep -cE '^[[:space:]]*[0-9]+\.[0-9]+\.' || true)"
        echo "IPv6 : $(nft list set inet nexashield v6 | tr ',{}' '\n\n\n' | grep -cE '^[[:space:]]*[0-9a-f]*:[0-9a-f:]+[[:space:]]*$' || true)"
        nft list chain inet nexashield input | grep counter
    elif command -v ipset >/dev/null && ipset list -n 2>/dev/null | grep -q nexashield-v4; then
        echo "moteur / engine : ipset"; ipset list nexashield-v4 | grep -m1 'Number of entries' || true
    else echo "non actif / not active"; fi
}
[ "${1:-update}" = "status" ] && { status; exit 0; }

curl -fsS --proto =https --tlsv1.2 --max-time 60 --retry 3 -o "$TMP/raw" "$URL"
grep -vxF -f <(grep -v '^#' "$ALLOW" 2>/dev/null | tr -d ' \r' | grep . || echo none) "$TMP/raw" > "$TMP/f" || true
grep -E '^([0-9]{1,3}\.){3}[0-9]{1,3}$' "$TMP/f" | sort -u > "$TMP/v4" || true
grep -E '^[0-9A-Fa-f:]+:[0-9A-Fa-f:]*$' "$TMP/f" | sort -u > "$TMP/v6" || true
N4=$(wc -l < "$TMP/v4"); N6=$(wc -l < "$TMP/v6")
[ $((N4 + N6)) -ge $MIN ] || { echo "liste trop courte ($((N4 + N6))) : rien appliqué / list too short, nothing applied" >&2; exit 1; }

if command -v nft >/dev/null; then
    els() { paste -sd, "$1"; }
    {
        echo "table inet nexashield"
        echo "delete table inet nexashield"
        echo "table inet nexashield {"
        echo "  set v4 { type ipv4_addr; flags interval; auto-merge; $( [ "$N4" -gt 0 ] && echo "elements = { $(els "$TMP/v4") };" ) }"
        echo "  set v6 { type ipv6_addr; flags interval; auto-merge; $( [ "$N6" -gt 0 ] && echo "elements = { $(els "$TMP/v6") };" ) }"
        echo "  chain input  { type filter hook input priority -10; policy accept; ip saddr @v4 counter drop; ip6 saddr @v6 counter drop; }"
        echo "  chain forward { type filter hook forward priority -10; policy accept; ip saddr @v4 counter drop; ip6 saddr @v6 counter drop; }"
        echo "  chain output { type filter hook output priority -10; policy accept; ip daddr @v4 counter drop; ip6 daddr @v6 counter drop; }"
        echo "}"
    } > "$TMP/rules.nft"
    nft -f "$TMP/rules.nft"                     # remplacement atomique / atomic swap
else
    for v in 4 6; do
        fam=inet; [ $v = 6 ] && fam=inet6
        ipset create nexashield-v$v hash:ip family $fam -exist
        ipset create nexashield-v$v-new hash:ip family $fam -exist
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
        $t -C OUTPUT -j NEXASHIELD 2>/dev/null || $t -I OUTPUT 1 -j NEXASHIELD
    done
fi
logger -t nexashield "blocklist: $N4 IPv4, $N6 IPv6" 2>/dev/null || true
echo "NexaShield : $N4 IPv4 + $N6 IPv6 bloquées / blocked"
EOF
chmod 755 "$BIN"

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
    systemctl daemon-reload
    systemctl enable --now nexashield-blocklist.timer >/dev/null
    PLAN="timer systemd (toutes les heures / hourly)"
else
    echo "$((RANDOM % 60)) * * * * root $BIN update >/dev/null 2>&1" > /etc/cron.d/nexashield-blocklist
    echo "@reboot root sleep 120 && $BIN update >/dev/null 2>&1" >> /etc/cron.d/nexashield-blocklist
    PLAN="cron (toutes les heures / hourly)"
fi

"$BIN" update
cat <<EOF

  🛡️  NexaShield Abuse IP est actif / is active.
      Mise à jour automatique : $PLAN
      Exceptions / allowlist : $CONF/allowlist.txt
      État / status          : sudo nexashield-blocklist status
      Désinstaller           : sudo bash install.sh --uninstall

  Cette liste n'est qu'un aperçu. Pour une détection et une réponse complètes
  (EDR · XDR · NDR · MDR) : contact@bastivan.com · https://bastivan.com
EOF
