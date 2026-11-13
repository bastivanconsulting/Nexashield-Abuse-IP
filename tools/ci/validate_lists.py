#!/usr/bin/env python3
"""Contrôle qualité des listes publiées (CI). Bibliothèque standard uniquement.

Bloque la CI si : adresse invalide, adresse privée / réservée / documentation, doublon,
incohérence entre formats, JSON / STIX / YAML mal formé, ou liste anormalement courte.
"""
import csv, ipaddress, json, re, sys
from pathlib import Path

ROOT = Path(sys.argv[1] if len(sys.argv) > 1 else ".")
L = ROOT / "lists"
MIN = 10
errors = []


def err(msg):
    errors.append(msg)
    print(f"::error::{msg}")


def lines(p):
    return [l.strip() for l in (L / p).read_text().splitlines() if l.strip() and not l.startswith(("#", "!"))]


ref = lines("plain/all.txt")
if len(ref) < MIN:
    err(f"plain/all.txt : {len(ref)} adresse(s), minimum {MIN}")
if len(set(ref)) != len(ref):
    err("plain/all.txt : doublons")
for s in ref:
    try:
        a = ipaddress.ip_address(s)
    except ValueError:
        err(f"adresse invalide : {s!r}")
        continue
    # Une adresse non routable publiée par erreur bloquerait le réseau interne de nos utilisateurs
    if not a.is_global or a.is_multicast:
        err(f"adresse non publique dans la liste : {s}")
    if str(a) != s:
        err(f"adresse non canonique : {s} (attendu {a})")
R = set(ref)
v4 = {s for s in R if ":" not in s}
v6 = R - v4

checks = {
    "plain/ipv4.txt": set(lines("plain/ipv4.txt")) == v4,
    "plain/ipv6.txt": set(lines("plain/ipv6.txt")) == v6,
    "blocklist.txt": set(lines("blocklist.txt")) == R,
    "nginx-deny.conf": {re.fullmatch(r"deny (\S+);", l).group(1) for l in lines("nginx-deny.conf")} == R,
    "apache-deny.conf": {l.split()[-1] for l in lines("apache-deny.conf") if l.startswith("Require not ip")} == R,
    "cisco-asa.txt": {l.split()[-1] for l in lines("cisco-asa.txt") if l.startswith("network-object host")} == R,
    "cisco-ios.txt": {l.split()[-1] for l in lines("cisco-ios.txt") if l.startswith("host ")} == v4,
    "mikrotik.rsc": {re.search(r"address=(\S+?)(?:/128)?\s", l).group(1) for l in lines("mikrotik.rsc") if " add " in l} == R,
    "wazuh-cdb.txt": {l.rsplit(":", 1)[0].strip('"') for l in lines("wazuh-cdb.txt")} == R,
    "crowdsec-decisions.json": {d["value"] for d in json.loads((L / "crowdsec-decisions.json").read_text())} == R,
    "abuse-ip.json": {d["ip"] for d in json.loads((L / "abuse-ip.json").read_text())} == R,
    "abuse-ip.csv": {r["ip"] for r in csv.DictReader((L / "abuse-ip.csv").open())} == R,
}
for name, ok in checks.items():
    if not ok:
        err(f"{name} ne contient pas exactement les mêmes adresses que plain/all.txt")

# Suricata : chaque adresse présente une fois, SID uniques
sur = [l for l in lines("suricata.rules")]
sids = [int(re.search(r"sid:(\d+);", l).group(1)) for l in sur]
ips_sur = [i for l in sur for i in re.search(r"\[([^\]]*)\]", l).group(1).split(",")]
if len(set(sids)) != len(sids) or set(ips_sur) != R or len(ips_sur) != len(R):
    err("suricata.rules : SID dupliqué ou adresses incohérentes")

# STIX 2.1 : structure minimale, identifiants uniques et motif cohérent
b = json.loads((L / "stix2-bundle.json").read_text())
ids = [o["id"] for o in b["objects"]]
inds = [o for o in b["objects"] if o["type"] == "indicator"]
if b.get("type") != "bundle" or len(set(ids)) != len(ids):
    err("stix2-bundle.json : bundle invalide ou identifiants dupliqués")
pat = re.compile(r"\[ipv[46]-addr:value = '([^']+)'\]")
if {pat.fullmatch(o["pattern"]).group(1) for o in inds} != R:
    err("stix2-bundle.json : indicateurs incohérents avec plain/all.txt")
for o in inds:
    for k in ("created", "modified", "valid_from"):
        if not re.fullmatch(r"\d{4}-\d\d-\d\dT\d\d:\d\d:\d\d\.\d{3}Z", o[k]):
            err(f"stix2-bundle.json : horodatage invalide {o['id']} {k}")

# Kubernetes (Cilium) : uniquement des refus, jamais de refus par défaut
y = (L / "kubernetes" / "cilium-clusterwide-deny.yaml").read_text()
cidr = re.findall(r"- cidr: (\S+)", y)
if "ingress: false" not in y or "egress: false" not in y or re.search(r"^\s+(ingress|egress):\s*$", y, re.M):
    err("cilium : enableDefaultDeny doit rester à false et aucune règle d'autorisation n'est permise")
if {c.rsplit("/", 1)[0] for c in cidr} != R or len(cidr) != 2 * len(R):
    err("cilium : CIDR incohérents avec plain/all.txt")

print(f"{len(R)} adresses ({len(v4)} IPv4, {len(v6)} IPv6), {len(checks) + 3} formats contrôlés, {len(errors)} erreur(s)")
sys.exit(1 if errors else 0)
