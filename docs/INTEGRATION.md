# 🔌 Intégrer la liste NexaShield dans votre équipement

La liste est mise à jour automatiquement par le SOC NexaShield. Choisissez le fichier adapté à votre équipement et laissez-le se rafraîchir tout seul.

## 📥 Fichiers disponibles

| Fichier | Format | Pour |
|---|---|---|
| [`lists/plain/all.txt`](../lists/plain/all.txt) | une IP par ligne, sans commentaire (IPv4 + IPv6) | flux « URL » : Fortinet, pfSense, OPNsense, Cisco FMC, Windows… |
| [`lists/plain/ipv4.txt`](../lists/plain/ipv4.txt) | une IPv4 par ligne, sans commentaire | équipements IPv4 seulement |
| [`lists/plain/ipv6.txt`](../lists/plain/ipv6.txt) | une IPv6 par ligne, sans commentaire | équipements IPv6 |
| [`lists/blocklist.txt`](../lists/blocklist.txt) | une IP par ligne, en-tête `#` | scripts, Fail2ban, ipset |
| [`lists/mikrotik.rsc`](../lists/mikrotik.rsc) | script RouterOS | MikroTik |
| [`lists/cisco-asa.txt`](../lists/cisco-asa.txt) | `object-group network` | Cisco ASA |
| [`lists/cisco-ios.txt`](../lists/cisco-ios.txt) | `object-group network` (IPv4) | Cisco IOS / IOS-XE |
| [`lists/nginx-deny.conf`](../lists/nginx-deny.conf) | directives `deny` | nginx |
| [`lists/abuse-ip.csv`](../lists/abuse-ip.csv) · [`.json`](../lists/abuse-ip.json) | détail complet (pays, ASN, natures, dates) | SIEM, analyse |

URL brute à utiliser (remplacez le chemin du fichier) :
```
https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/lists/plain/all.txt
```

> 🚀 **Le plus simple : les installateurs**, qui bloquent et **se mettent à jour tout seuls toutes les heures**
> - Linux : [`tools/linux/install.sh`](../tools/linux/install.sh) (nftables ou ipset, timer systemd ou cron)
> - Windows : [`tools/windows/Install-NexaShield.ps1`](../tools/windows/Install-NexaShield.ps1) (tâche planifiée SYSTEM)
> - MikroTik RouterOS v7 : [`tools/mikrotik/install.rsc`](../tools/mikrotik/install.rsc) (planificateur + table raw)
>
> Les sections ci-dessous détaillent l'intégration manuelle.

> ⚠️ **Avant de bloquer en production** : vérifiez que la liste ne contient pas l'IP d'un partenaire ou d'un service que vous utilisez, commencez si possible en mode journalisation, et placez la règle de blocage **en tête** de vos règles d'entrée.

---

## <img src="../assets/logos/fortinet.svg" width="26" height="26" align="center" alt="fortinet"> Fortinet FortiGate (FortiOS 6.4 / 7.x)

**Interface** : *Security Fabric › External Connectors › Create New › Threat Feeds › IP Address*
- Nom : `NexaShield-Abuse-IP`
- URI : `https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/lists/plain/all.txt`
- Refresh rate : `60` minutes

**CLI**
```
config system external-resource
    edit "NexaShield-Abuse-IP"
        set type address
        set resource "https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/lists/plain/all.txt"
        set refresh-rate 60
    next
end
```
Utilisez ensuite `NexaShield-Abuse-IP` comme **adresse source** d'une règle `DENY` placée en haut de vos règles WAN → LAN (et comme destination d'une règle LAN → WAN pour bloquer aussi les connexions sortantes).

---

## <img src="../assets/logos/mikrotik.svg" width="26" height="26" align="center" alt="mikrotik"> MikroTik RouterOS (v6 / v7)

Import immédiat :
```
/tool fetch url="https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/lists/mikrotik.rsc" dst-path=nexashield.rsc
/import file-name=nexashield.rsc
```
Mise à jour automatique toutes les 6 heures :
```
/system scheduler add name=nexashield-abuse interval=6h start-time=startup on-event="/tool fetch url=\"https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/lists/mikrotik.rsc\" dst-path=nexashield.rsc; :delay 10s; /import file-name=nexashield.rsc"
```
Blocage (table *raw*, avant le suivi de connexion, donc peu coûteux) :
```
/ip firewall raw add chain=prerouting src-address-list=nexashield-abuse action=drop comment="NexaShield abuse IP"
/ipv6 firewall raw add chain=prerouting src-address-list=nexashield-abuse action=drop comment="NexaShield abuse IP"
```

---

## <img src="../assets/logos/cisco.svg" width="26" height="26" align="center" alt="cisco"> Cisco

**Cisco ASA** : collez le contenu de [`lists/cisco-asa.txt`](../lists/cisco-asa.txt) en mode configuration, puis :
```
access-list OUTSIDE_IN line 1 extended deny ip object-group NEXASHIELD-ABUSE any
```
(remplacez `OUTSIDE_IN` par le nom de l'ACL appliquée à votre interface externe). Pour une mise à jour, supprimez d'abord l'objet existant (`no object-group network NEXASHIELD-ABUSE` après avoir retiré la ligne d'ACL) ou utilisez votre outil d'automatisation (Ansible, etc.).

**Cisco IOS / IOS-XE** : collez [`lists/cisco-ios.txt`](../lists/cisco-ios.txt), puis ajoutez en tête de votre ACL d'entrée :
```
ip access-list extended OUTSIDE_IN
 1 deny ip object-group NEXASHIELD-ABUSE any
```

**Cisco Secure Firewall (FTD) avec FMC** : *Objects › Object Management › Security Intelligence › Network Lists and Feeds › Add Network Lists and Feeds*, type **Feed**, URL `…/lists/plain/all.txt`, fréquence de mise à jour 1 heure ; ajoutez ensuite le flux en **Block** dans l'onglet *Security Intelligence* de votre politique de contrôle d'accès.

---

## <img src="../assets/logos/pfsense.svg" width="26" height="26" align="center" alt="pfsense"> pfSense

1. *Firewall › Aliases › URLs › Add*
   - Name : `NexaShield_Abuse_IP`
   - Type : **URL Table (IPs)**
   - URL : `https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/lists/plain/all.txt`
   - Update frequency : `1` (jour)
2. *Firewall › Rules › WAN* : règle **Block**, Source = alias `NexaShield_Abuse_IP`, placée **en premier**.

Avec **pfBlockerNG** : *Firewall › pfBlockerNG › IP › IPv4 (et IPv6)*, ajoutez l'URL comme source, Action **Deny Inbound** (ou *Deny Both*).

---

## <img src="../assets/logos/opnsense.svg" width="26" height="26" align="center" alt="opnsense"> OPNsense

1. *Firewall › Aliases › Add*
   - Name : `NexaShield_Abuse_IP`
   - Type : **URL Table (IPs)**
   - Refresh Frequency : `1` jour
   - Content : `https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/lists/plain/all.txt`
2. *Firewall › Rules › WAN* : règle **Block**, Source = `NexaShield_Abuse_IP`, en tête de liste, puis **Apply**.

---

## <img src="../assets/logos/windows.svg" width="26" height="26" align="center" alt="windows"> Windows (Windows Defender Firewall)

Script prêt à l'emploi : [`tools/windows/Update-NexaShieldBlocklist.ps1`](../tools/windows/Update-NexaShieldBlocklist.ps1). Il télécharge la liste, valide chaque adresse et crée deux règles de blocage (entrée et sortie).

PowerShell **administrateur** :
```powershell
New-Item -ItemType Directory -Force C:\NexaShield | Out-Null
Invoke-WebRequest -UseBasicParsing -OutFile C:\NexaShield\Update-NexaShieldBlocklist.ps1 `
  https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/tools/windows/Update-NexaShieldBlocklist.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File C:\NexaShield\Update-NexaShieldBlocklist.ps1
```
Mise à jour quotidienne automatique :
```powershell
$a = New-ScheduledTaskAction -Execute "powershell.exe" -Argument '-NoProfile -ExecutionPolicy Bypass -File "C:\NexaShield\Update-NexaShieldBlocklist.ps1"'
$t = New-ScheduledTaskTrigger -Daily -At 6am
Register-ScheduledTask -TaskName "NexaShield Abuse IP" -Action $a -Trigger $t -User "SYSTEM" -RunLevel Highest
```
Lisez le script avant de l'exécuter : c'est une bonne pratique pour tout code téléchargé.

---

## <img src="../assets/logos/linux.svg" width="26" height="26" align="center" alt="linux"> Linux

**ipset + iptables**
```bash
ipset create nexashield-abuse hash:ip -exist
ipset flush nexashield-abuse
curl -fsSL https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/lists/plain/ipv4.txt \
  | xargs -r -n1 ipset add nexashield-abuse -exist
iptables -C INPUT -m set --match-set nexashield-abuse src -j DROP 2>/dev/null \
  || iptables -I INPUT -m set --match-set nexashield-abuse src -j DROP
```

**nftables**
```bash
nft add table inet nexashield
nft add set inet nexashield abuse '{ type ipv4_addr; flags interval; }'
nft add chain inet nexashield input '{ type filter hook input priority -10; }'
nft add rule inet nexashield input ip saddr @abuse drop
curl -fsSL https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/lists/plain/ipv4.txt \
  | xargs -r -I{} nft add element inet nexashield abuse '{ {} }'
```

**UFW**
```bash
curl -fsSL https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/lists/plain/all.txt \
  | xargs -r -I{} ufw insert 1 deny from {}
```

Planifiez ces commandes avec `cron` ou un timer systemd (par exemple toutes les 6 heures).

---

## <img src="../assets/logos/nginx.svg" width="26" height="26" align="center" alt="nginx"> nginx

```bash
curl -fsSL -o /etc/nginx/conf.d/nexashield-deny.conf \
  https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/lists/nginx-deny.conf
nginx -t && systemctl reload nginx
```
Le fichier contient des directives `deny` valables dans le bloc `http` (inclus automatiquement depuis `conf.d/`).

---

## 🧰 Autres équipements

Tout équipement capable de lire une liste d'adresses par URL (Stormshield, Sophos, Palo Alto *External Dynamic List*, Check Point, WatchGuard, Ubiquiti…) peut utiliser :
```
https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/lists/plain/all.txt
```
Reportez-vous à la documentation de votre constructeur pour l'écran exact.

---

<div align="center">

**Besoin d'aide pour l'intégrer, ou d'une protection complète EDR · XDR · NDR · MDR ?**
📧 [contact@bastivan.com](mailto:contact@bastivan.com) · 🌍 [bastivan.com](https://bastivan.com)

</div>
