<picture>
  <source width="100%" srcset="assets/banner-dark.svg" media="(prefers-color-scheme: dark)">
  <source width="100%" srcset="assets/banner-light.svg" media="(prefers-color-scheme: light), (prefers-color-scheme: no-preference)">
  <img width="100%" src="assets/banner-light.svg" alt="NexaShield Abuse IP">
</picture>

<h1 align="center">NexaShield Abuse IP</h1>

<p align="center"><b>We built it to protect our infrastructure.<br>We share it for free to protect yours.</b></p>

<p align="center">Every address on this list really attacked a server we protect.<br>Our SOC detected it, proved it and reported it to its network owner. Block it before it hits you.</p>

<p align="center">
  [<a href="docs/INTEGRATION.md">Integration guide</a>]
  [<a href="lists/plain/all.txt">Raw list</a>]
  [<a href="analysis/latest.md">AI analysis (FR)</a>]
  [<a href="https://bastivan.com">Bastivan Consulting</a>]
  [<a href="README.md">Français</a>]
</p>

<p align="center">
  <img src="https://img.shields.io/badge/malicious%20IPs-8708-dc2626?style=flat&labelColor=080f12" alt="IPs">
  <img src="https://img.shields.io/badge/countries-93-2563eb?style=flat&labelColor=080f12" alt="Countries">
  <img src="https://img.shields.io/badge/updated-2026--11--25-1fa669?style=flat&labelColor=080f12" alt="Updated">
  <a href="https://github.com/bastivanconsulting/Nexashield-Abuse-IP/actions/workflows/ci.yml"><img src="https://github.com/bastivanconsulting/Nexashield-Abuse-IP/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
  <a href="https://github.com/bastivanconsulting/Nexashield-Abuse-IP/stargazers"><img src="https://img.shields.io/github/stars/bastivanconsulting/Nexashield-Abuse-IP?style=flat&labelColor=080f12&color=eab308&logo=github" alt="Stars"></a>
  <img src="https://img.shields.io/github/last-commit/bastivanconsulting/Nexashield-Abuse-IP?style=flat&labelColor=080f12&color=64748b" alt="Last commit">
  <a href="https://creativecommons.org/licenses/by/4.0/"><img src="https://img.shields.io/badge/license-CC%20BY%204.0-0ea5e9?style=flat&labelColor=080f12" alt="CC BY 4.0"></a>
  <img src="https://img.shields.io/badge/made%20in-France-0055A4?style=flat&labelColor=080f12" alt="Made in France">
</p>

<p align="center">
  <a href="https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/lists/plain/all.txt"><picture>
    <source width="32%" srcset="assets/btn-download-en-dark.svg" media="(prefers-color-scheme: dark)">
    <img width="32%" src="assets/btn-download-en-light.svg" alt="Download the list">
  </picture></a>
  <a href="docs/INTEGRATION.md"><picture>
    <source width="32%" srcset="assets/btn-plug-en-dark.svg" media="(prefers-color-scheme: dark)">
    <img width="32%" src="assets/btn-plug-en-light.svg" alt="Integrate in 5 minutes">
  </picture></a>
  <a href="mailto:contact@bastivan.com?subject=NexaShield"><picture>
    <source width="32%" srcset="assets/btn-shield-en-dark.svg" media="(prefers-color-scheme: dark)">
    <img width="32%" src="assets/btn-shield-en-light.svg" alt="Protect my company">
  </picture></a>
</p>

<picture>
  <source width="100%" srcset="assets/stats-en-dark.svg" media="(prefers-color-scheme: dark)">
  <img width="100%" src="assets/stats-en-light.svg" alt="Stats: 8708 IPs, 93 countries, 715 networks, 547833 events">
</picture>

> [!TIP]
> **One URL for all your firewalls**, refreshed automatically:
> `https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/lists/plain/all.txt`

## 💡 Why we publish it

NexaShield protects **our own infrastructure** first. Every hour it sees bots guessing passwords, probing for known vulnerabilities or slipping malicious code into web forms. The same addresses hit you too, often without anyone noticing.

Keeping that knowledge to ourselves made no sense. So we publish it: **free, no sign-up, no API key**. One command is enough for your firewall to block what our SOC has already seen and proven.

And the more networks shut the door on these addresses, the less they pay off for the people running them. **Every block counts.**

## ✨ Why this list is different

- [x] **Seen attacks, not rumours**: every IP really hit infrastructure monitored by NexaShield. No copied feeds.
- [x] **Evidence thresholds** per attack type; known false positives removed (CDNs, search engines, research scanners, spoofable UDP).
- [x] **Reported at the source**: the network's official abuse contact receives redacted evidence before publication.
- [x] **Hands-off updates**: the SOC checks every hour and publishes as soon as a new attack is confirmed.
- [x] **Ready to use**: Fortinet, MikroTik, Cisco, pfSense, OPNsense, Windows, Linux… and Wazuh, CrowdSec, Suricata, OpenCTI, MISP, Splunk, Kubernetes.
- [x] **Built for analysis**: country → network (ASN) → IP, with a readable page and a JSON record for every address.
- [x] **Zero customer data**: no hostnames, no targets, no raw logs.

## 📊 Your own dashboard, on your machine

The Linux installer opens a **local dashboard** at `http://127.0.0.1:8787`: see live what NexaShield blocks **on this machine**.

- 🛡️ **Protection status**: list freshness, active engine, protected since.
- 📈 **Blocked attempts**: total, today, per day and hour by hour.
- 🌍 **Map of attackers stopped on your machine**, with country, network and attack type.
- 🔎 **Lookup**: is an IP listed, and has it already tried to reach you?

Nothing leaves your machine: counters come from your own firewall, the page only listens locally (remote access via `ssh -L 8787:127.0.0.1:8787 your-server`), and the web server runs with no privileges at all.

## 🚀 30-second install, automatic updates

The installers block **inbound and outbound** traffic, then **update themselves every hour**. Local allowlist, safeguard against truncated downloads, one-command uninstall.

<details open>
<summary><img src="assets/logos/linux.svg" width="18" height="18" align="center" alt="linux"> <b>Linux</b> (nftables or ipset + iptables, systemd timer or cron)</summary>

```bash
curl -fsSLO https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/tools/linux/install.sh
less install.sh          # always read a script before running it
sudo bash install.sh
```
Dashboard: `http://127.0.0.1:8787` · status: `sudo nexashield-blocklist status` · allowlist: `/etc/nexashield/allowlist.txt` · uninstall: `sudo bash install.sh --uninstall`
</details>

<details>
<summary><img src="assets/logos/windows.svg" width="18" height="18" align="center" alt="windows"> <b>Windows</b> (Windows Defender Firewall, scheduled task)</summary>

**Administrator** PowerShell:
```powershell
$u = "https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/tools/windows"
iwr -UseBasicParsing "$u/Install-NexaShield.ps1" -OutFile Install-NexaShield.ps1
iwr -UseBasicParsing "$u/Update-NexaShieldBlocklist.ps1" -OutFile Update-NexaShieldBlocklist.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .\Install-NexaShield.ps1
```
Allowlist: `C:\ProgramData\NexaShield\allowlist.txt` · uninstall: `.\Install-NexaShield.ps1 -Uninstall`
</details>

<details>
<summary><img src="assets/logos/mikrotik.svg" width="18" height="18" align="center" alt="mikrotik"> <b>MikroTik RouterOS v7</b> (scheduler, raw table)</summary>

```
/tool fetch url="https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/tools/mikrotik/install.rsc" dst-path=nexashield-install.rsc
/import file-name=nexashield-install.rsc
```
</details>

<details>
<summary><img src="assets/logos/fortinet.svg" width="18" height="18" align="center" alt="fortinet"> <b>Fortinet FortiGate</b> (Threat Feed, refreshed by the firewall)</summary>

```
config system external-resource
    edit "NexaShield-Abuse-IP"
        set type address
        set resource "https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/lists/plain/all.txt"
        set refresh-rate 60
    next
end
```
</details>

Cisco, pfSense, OPNsense, nftables, UFW, nginx: **[full guide (FR) →](docs/INTEGRATION.md)**

---

## 📊 Threat landscape

<table>
<tr>
<td valign="top" width="50%">

#### 🌍 Top countries

| Country | IPs |
|---|---:|
| 🇺🇸 [United States](countries/US_United-States/) | 3502 |
| 🇬🇧 [United Kingdom](countries/GB_United-Kingdom/) | 1028 |
| 🇳🇱 [The Netherlands](countries/NL_The-Netherlands/) | 722 |
| 🇩🇪 [Germany](countries/DE_Germany/) | 628 |
| 🇧🇪 [Belgium](countries/BE_Belgium/) | 447 |
| 🇫🇷 [France](countries/FR_France/) | 392 |
| 🇭🇰 [Hong Kong](countries/HK_Hong-Kong/) | 234 |
| 🇨🇳 [China](countries/CN_China/) | 223 |
| 🇸🇬 [Singapore](countries/SG_Singapore/) | 165 |
| 🇯🇵 [Japan](countries/JP_Japan/) | 152 |
| 🇲🇾 [Malaysia](countries/MY_Malaysia/) | 103 |
| 🇸🇪 [Sweden](countries/SE_Sweden/) | 100 |
| 🇦🇩 [Andorra](countries/AD_Andorra/) | 95 |
| 🇮🇳 [India](countries/IN_India/) | 85 |
| 🇧🇷 [Brazil](countries/BR_Brazil/) | 84 |

➡️ [All countries](countries/)

</td>
<td valign="top" width="50%">

#### 🎯 Attack types

| Type | IPs |
|---|---:|
| Port scanning | 8071 |
| Known botnet / C2 infrastructure | 6590 |
| SSH brute force | 583 |
| Abusive HTTP requests | 566 |
| Exploitation attempt (CVE / RCE / injection) | 484 |
| Web injection payload blocked by WAF | 209 |
| Spamhaus DROP-listed network | 80 |
| UDP exploit signature | 2 |
| SMTP / IMAP credential guessing | 1 |

</td>
</tr>
</table>

#### 🏢 Top networks (ASN)

| ASN | Owner | Countries (IPs) | Total IPs |
|---|---|---|---:|
| **AS8075** | Microsoft Corporation | [🇺🇸 1160](countries/US_United-States/AS8075_Microsoft-Corporation/) [🇦🇪 3](countries/AE_United-Arab-Emirates/AS8075_Microsoft-Corporation/) [🇮🇳 3](countries/IN_India/AS8075_Microsoft-Corporation/) [🇳🇱 2](countries/NL_The-Netherlands/AS8075_Microsoft-Corporation/) [🇿🇦 2](countries/ZA_South-Africa/AS8075_Microsoft-Corporation/) [🇧🇷 1](countries/BR_Brazil/AS8075_Microsoft-Corporation/) [🇩🇰 1](countries/DK_Denmark/AS8075_Microsoft-Corporation/) [🇮🇪 1](countries/IE_Ireland/AS8075_Microsoft-Corporation/) [🇮🇱 1](countries/IL_Israel/AS8075_Microsoft-Corporation/) | 1174 |
| **AS25369** | Hydra Communications Ltd | [🇬🇧 722](countries/GB_United-Kingdom/AS25369_Hydra-Communications-Ltd/) [🇳🇱 219](countries/NL_The-Netherlands/AS25369_Hydra-Communications-Ltd/) [🇩🇪 63](countries/DE_Germany/AS25369_Hydra-Communications-Ltd/) | 1004 |
| **AS45102** | Alibaba (US) Technology Co., Ltd. | [🇺🇸 180](countries/US_United-States/AS45102_Alibaba-US-Technology-Co-Ltd/) [🇸🇬 118](countries/SG_Singapore/AS45102_Alibaba-US-Technology-Co-Ltd/) [🇯🇵 114](countries/JP_Japan/AS45102_Alibaba-US-Technology-Co-Ltd/) [🇩🇪 108](countries/DE_Germany/AS45102_Alibaba-US-Technology-Co-Ltd/) [🇲🇾 101](countries/MY_Malaysia/AS45102_Alibaba-US-Technology-Co-Ltd/) [🇵🇭 1](countries/PH_Philippines/AS45102_Alibaba-US-Technology-Co-Ltd/) | 622 |
| **AS396982** | Google LLC | [🇬🇧 202](countries/GB_United-Kingdom/AS396982_Google-LLC/) [🇺🇸 159](countries/US_United-States/AS396982_Google-LLC/) [🇧🇪 63](countries/BE_Belgium/AS396982_Google-LLC/) [🇫🇷 18](countries/FR_France/AS396982_Google-LLC/) [🇯🇵 6](countries/JP_Japan/AS396982_Google-LLC/) [🇩🇪 5](countries/DE_Germany/AS396982_Google-LLC/) [🇰🇷 4](countries/KR_South-Korea/AS396982_Google-LLC/) [🇧🇷 3](countries/BR_Brazil/AS396982_Google-LLC/) [🇨🇱 3](countries/CL_Chile/AS396982_Google-LLC/) [🇭🇰 3](countries/HK_Hong-Kong/AS396982_Google-LLC/) [🇳🇱 3](countries/NL_The-Netherlands/AS396982_Google-LLC/) [🇹🇼 3](countries/TW_Taiwan/AS396982_Google-LLC/) [🇦🇺 2](countries/AU_Australia/AS396982_Google-LLC/) [🇨🇦 2](countries/CA_Canada/AS396982_Google-LLC/) [🇮🇳 2](countries/IN_India/AS396982_Google-LLC/) [🇸🇬 2](countries/SG_Singapore/AS396982_Google-LLC/) [🇪🇸 1](countries/ES_Spain/AS396982_Google-LLC/) [🇮🇩 1](countries/ID_Indonesia/AS396982_Google-LLC/) [🇮🇱 1](countries/IL_Israel/AS396982_Google-LLC/) [🇹🇭 1](countries/TH_Thailand/AS396982_Google-LLC/) | 484 |
| **AS398324** | Censys, Inc. | [🇺🇸 414](countries/US_United-States/AS398324_Censys-Inc/) | 414 |
| **AS43515** | Google Ireland Limited | [🇧🇪 383](countries/BE_Belgium/AS43515_Google-Ireland-Limited/) [🇳🇱 25](countries/NL_The-Netherlands/AS43515_Google-Ireland-Limited/) | 408 |
| **AS14618** | Amazon.com, Inc. | [🇺🇸 392](countries/US_United-States/AS14618_Amazon-com-Inc/) | 392 |
| **AS135377** | UCLOUD INFORMATION TECHNOLOGY (HK) LIMITED | [🇺🇸 88](countries/US_United-States/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) [🇭🇰 83](countries/HK_Hong-Kong/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) [🇹🇭 34](countries/TH_Thailand/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) [🇬🇧 32](countries/GB_United-Kingdom/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) [🇩🇪 20](countries/DE_Germany/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) [🇳🇬 17](countries/NG_Nigeria/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) [🇯🇵 12](countries/JP_Japan/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) [🇹🇼 9](countries/TW_Taiwan/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) [🇦🇪 8](countries/AE_United-Arab-Emirates/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) [🇰🇷 8](countries/KR_South-Korea/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) [🇵🇭 8](countries/PH_Philippines/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) [🇧🇷 7](countries/BR_Brazil/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) [🇮🇳 7](countries/IN_India/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) [🇸🇬 6](countries/SG_Singapore/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) [🇻🇳 6](countries/VN_Vietnam/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) [🇮🇩 4](countries/ID_Indonesia/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) [🇷🇺 4](countries/RU_Russia/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) | 353 |
| **AS213412** | ONYPHE SAS | [🇫🇷 184](countries/FR_France/AS213412_ONYPHE-SAS/) [🇺🇸 99](countries/US_United-States/AS213412_ONYPHE-SAS/) [🇨🇳 18](countries/CN_China/AS213412_ONYPHE-SAS/) | 301 |
| **AS14061** | DigitalOcean, LLC | [🇺🇸 119](countries/US_United-States/AS14061_DigitalOcean-LLC/) [🇩🇪 49](countries/DE_Germany/AS14061_DigitalOcean-LLC/) [🇸🇬 24](countries/SG_Singapore/AS14061_DigitalOcean-LLC/) [🇬🇧 22](countries/GB_United-Kingdom/AS14061_DigitalOcean-LLC/) [🇳🇱 16](countries/NL_The-Netherlands/AS14061_DigitalOcean-LLC/) [🇦🇺 10](countries/AU_Australia/AS14061_DigitalOcean-LLC/) [🇨🇦 6](countries/CA_Canada/AS14061_DigitalOcean-LLC/) [🇮🇳 6](countries/IN_India/AS14061_DigitalOcean-LLC/) | 252 |

---

## 🔧 Works with your devices

| Device | File / method |
|---|---|
| <img src="assets/logos/fortinet.svg" width="22" height="22" align="center" alt="fortinet"> **Fortinet FortiGate** | Threat Feed (External Connector) → [`lists/plain/all.txt`](lists/plain/all.txt) |
| <img src="assets/logos/mikrotik.svg" width="22" height="22" align="center" alt="mikrotik"> **MikroTik RouterOS** | installer [`tools/mikrotik/install.rsc`](tools/mikrotik/install.rsc) · list [`lists/mikrotik.rsc`](lists/mikrotik.rsc) |
| <img src="assets/logos/cisco.svg" width="22" height="22" align="center" alt="cisco"> **Cisco ASA / IOS / FTD** | [`lists/cisco-asa.txt`](lists/cisco-asa.txt) · [`lists/cisco-ios.txt`](lists/cisco-ios.txt) · FMC Security Intelligence feed |
| <img src="assets/logos/pfsense.svg" width="22" height="22" align="center" alt="pfsense"> **pfSense** (and pfBlockerNG) | *URL Table (IPs)* alias → [`lists/plain/all.txt`](lists/plain/all.txt) |
| <img src="assets/logos/opnsense.svg" width="22" height="22" align="center" alt="opnsense"> **OPNsense** | *URL Table (IPs)* alias → [`lists/plain/all.txt`](lists/plain/all.txt) |
| <img src="assets/logos/windows.svg" width="22" height="22" align="center" alt="windows"> **Windows** | installer [`tools/windows/Install-NexaShield.ps1`](tools/windows/Install-NexaShield.ps1) (scheduled task) |
| <img src="assets/logos/linux.svg" width="22" height="22" align="center" alt="linux"> **Linux** | installer [`tools/linux/install.sh`](tools/linux/install.sh) (nftables / ipset) · UFW → [`lists/plain/all.txt`](lists/plain/all.txt) |
| <img src="assets/logos/nginx.svg" width="22" height="22" align="center" alt="nginx"> **nginx** | [`lists/nginx-deny.conf`](lists/nginx-deny.conf) |
| <img src="assets/logos/paloaltonetworks.svg" width="22" height="22" align="center" alt="paloaltonetworks"> **Others** (Palo Alto EDL, Stormshield, Sophos, Check Point…) | any URL-based address list → [`lists/plain/all.txt`](lists/plain/all.txt) |

For SIEM or analysis: [`lists/abuse-ip.csv`](lists/abuse-ip.csv) · [`lists/abuse-ip.json`](lists/abuse-ip.json) (country, ASN, attack types, dates).

---

## 🧩 Plugs into your software

| SIEM & detection | Threat intelligence | Web & containers |
|---|---|---|
| **Wazuh** (CDB list) · [`wazuh-cdb.txt`](lists/wazuh-cdb.txt) | **OpenCTI** · **MISP** · **Sentinel** · [`stix2-bundle.json`](lists/stix2-bundle.json) | **Apache** · [`apache-deny.conf`](lists/apache-deny.conf) |
| **CrowdSec** · [`crowdsec-decisions.json`](lists/crowdsec-decisions.json) | Stable STIX 2.1 IDs: no duplicates | **HAProxy** · **Cloudflare** · **Proxmox VE** |
| **Suricata / Snort 3** · [`suricata.rules`](lists/suricata.rules) | | **Kubernetes / Cilium** · [`cilium-clusterwide-deny.yaml`](lists/kubernetes/cilium-clusterwide-deny.yaml) |
| **Splunk** · **Elastic** · **Graylog** · [`abuse-ip.csv`](lists/abuse-ip.csv) | | **Docker** (via the Linux installer) |

Step-by-step for each tool (FR): **[docs/SOFTWARE.md](docs/SOFTWARE.md)**

---

## 🧠 Behind this list: NexaShield

This list is a by-product. **NexaShield** is the detection and response platform of [Bastivan Consulting](https://bastivan.com), four layers working together:

| | Layer | What it does for you |
|:-:|---|---|
| 🖥️ | **EDR** · *Endpoint Detection & Response* | Watches every workstation and server (Linux, Windows, macOS, Kubernetes containers): processes, file integrity, persistence, privilege escalation, automatic malware quarantine. |
| 🌐 | **NDR** · *Network Detection & Response* | Continuous traffic analysis: exploit signatures, scans, suspicious DNS, *beaconing*, connections to known malicious infrastructure. |
| 🔗 | **XDR** · *Extended Detection & Response* | Correlates EDR, NDR, web, authentication and mail signals in real time to rebuild **the full attack timeline**, not just an isolated alert. |
| 👁️ | **MDR** · *Managed Detection & Response* | Our SOC (case management, threat intelligence, automatic IOC enrichment) watches, triages and responds for you. |

### 🆚 The free list… or NexaShield on your infrastructure

| | This list | NexaShield |
|---|:-:|:-:|
| Block IPs already seen by our SOC | ✅ | ✅ |
| Detect attacks targeting **your** endpoints, servers and containers | ❌ | ✅ |
| Analyse **your** network traffic (exploits, DNS, *beaconing*) | ❌ | ✅ |
| Rebuild the full attack timeline | ❌ | ✅ |
| Automatic ban, session kill, container isolation, quarantine | ❌ | ✅ |
| A SOC that triages your alerts and supports you | ❌ | ✅ |
| Audit-ready **NIS2 / DORA** reports | ❌ | ✅ |

<p align="center">
  <a href="mailto:contact@bastivan.com?subject=NexaShield"><img src="https://img.shields.io/badge/Protect%20my%20company-contact%40bastivan.com-dc2626?style=for-the-badge&labelColor=080f12" alt="Contact"></a>
  <a href="https://bastivan.com"><img src="https://img.shields.io/badge/Website-bastivan.com-2563eb?style=for-the-badge&labelColor=080f12" alt="bastivan.com"></a>
</p>

---

## ✅ How an IP gets here

<details>
<summary>Six evidence gates</summary>

1. **Real inbound attack** observed by NexaShield (never reputation alone).
2. **Evidence threshold** per type: 1 C2 contact, 2 exploits, 5 malicious web requests, 10 SSH failures.
3. **At least one application-level event**: a port scan alone is not enough.
4. **False positives removed**: CDNs, search engines, known scanning companies, UDP (spoofable), legitimate clients that logged in successfully.
5. **Abuse report** sent to the network's official contact (RIPEstat).
6. **Published** here, sorted by country, network and address.

Addresses **permanently banned** by NexaShield without an abuse report (repeat offenders, persistent low-level attacks judged by the AI, confirmed campaigns) are added too: their record says "not reported (permanent ban)".
</details>

## 🚫 Permanent bans (extended list)

On top of the reported addresses above, NexaShield publishes **every** address it has permanently banned on Bastivan Consulting infrastructure: repeat offenders, persistent low-level attacks judged by the AI, confirmed campaigns. Updated automatically every hour.

<!-- BANS:START -->
**7019** permanently banned addresses (**6935** IPs, **84** CIDR ranges), updated every hour: [`bans/permaban.txt`](bans/permaban.txt) (commented) · [`bans/plain/all.txt`](bans/plain/all.txt) (firewall feed) · [`ipv4`](bans/plain/ipv4.txt) / [`ipv6`](bans/plain/ipv6.txt).
<!-- BANS:END -->

> Not all of these addresses were reported to their hosting provider: for a strictly "reported and evidenced" blocklist, prefer [`lists/`](lists/).

## ⚠️ Disclaimer

- A listed IP is often a **compromised machine** or a short-lived rented server: its owner is not necessarily the attacker.
- Addresses change hands: use this data with a **limited lifetime** and at your own risk. Start in log-only mode.
- **Removal / dispute**: [removal request](https://github.com/bastivanconsulting/Nexashield-Abuse-IP/issues/new?template=removal-request.yml) or [contact@bastivan.com](mailto:contact@bastivan.com).

## 🤝 Community

[Contributing](CONTRIBUTING.md) · [Security policy](SECURITY.md) · [Code of conduct](CODE_OF_CONDUCT.md)

## ⭐ Support the project

If this list protects your network, **a star** helps other admins find it.

<a href="https://star-history.com/#bastivanconsulting/Nexashield-Abuse-IP&Date">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=bastivanconsulting/Nexashield-Abuse-IP&type=Date&theme=dark">
    <img width="100%" alt="Star history" src="https://api.star-history.com/svg?repos=bastivanconsulting/Nexashield-Abuse-IP&type=Date">
  </picture>
</a>

## 📜 License and attribution

- Data and scripts under **[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)**: credit "NexaShield Abuse IP · Bastivan Consulting".
- IP geolocation by **[DB-IP](https://db-ip.com)** (CC BY 4.0). Network owners and abuse contacts: **[RIPEstat](https://stat.ripe.net)**.
- Device logos: [Simple Icons](https://simpleicons.org) (CC0). Trademarks belong to their owners and only indicate compatibility.

---

<div align="center">

**🛡️ NexaShield** · *Detect. Correlate. Respond.*

© 2026 [Bastivan Consulting SAS](https://bastivan.com) · Consulting, managed services, cloud and cybersecurity · Beauvais, France

</div>
