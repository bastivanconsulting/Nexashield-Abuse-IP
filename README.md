<picture>
  <source width="100%" srcset="assets/banner-dark.svg" media="(prefers-color-scheme: dark)">
  <source width="100%" srcset="assets/banner-light.svg" media="(prefers-color-scheme: light), (prefers-color-scheme: no-preference)">
  <img width="100%" src="assets/banner-light.svg" alt="NexaShield Abuse IP">
</picture>

<h1 align="center">NexaShield Abuse IP</h1>

<p align="center"><b>Nous l'avons construit pour protéger notre infrastructure.<br>Nous le partageons gratuitement pour protéger la vôtre.</b></p>

<p align="center">Chaque adresse de cette liste a réellement attaqué un serveur que nous protégeons.<br>Notre SOC l'a détectée, prouvée et signalée à son hébergeur. À vous de la bloquer avant qu'elle ne frappe chez vous.</p>

<p align="center">
  [<a href="docs/INTEGRATION.md">Guide d'intégration</a>]
  [<a href="lists/plain/all.txt">Liste brute</a>]
  [<a href="analysis/latest.md">Analyse IA</a>]
  [<a href="https://bastivan.com">Bastivan Consulting</a>]
  [<a href="README.en.md">English</a>]
</p>

<p align="center">
  <img src="https://img.shields.io/badge/IP%20malveillantes-6126-dc2626?style=flat&labelColor=080f12" alt="IP">
  <img src="https://img.shields.io/badge/pays-72-2563eb?style=flat&labelColor=080f12" alt="Pays">
  <img src="https://img.shields.io/badge/mise%20à%20jour-2026--11--20-1fa669?style=flat&labelColor=080f12" alt="Mise à jour">
  <a href="https://github.com/bastivanconsulting/Nexashield-Abuse-IP/actions/workflows/ci.yml"><img src="https://github.com/bastivanconsulting/Nexashield-Abuse-IP/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
  <a href="https://github.com/bastivanconsulting/Nexashield-Abuse-IP/stargazers"><img src="https://img.shields.io/github/stars/bastivanconsulting/Nexashield-Abuse-IP?style=flat&labelColor=080f12&color=eab308&logo=github" alt="Étoiles"></a>
  <img src="https://img.shields.io/github/last-commit/bastivanconsulting/Nexashield-Abuse-IP?style=flat&labelColor=080f12&color=64748b&label=dernier%20commit" alt="Dernier commit">
  <a href="https://creativecommons.org/licenses/by/4.0/"><img src="https://img.shields.io/badge/licence-CC%20BY%204.0-0ea5e9?style=flat&labelColor=080f12" alt="CC BY 4.0"></a>
  <img src="https://img.shields.io/badge/made%20in-France-0055A4?style=flat&labelColor=080f12" alt="Made in France">
</p>

<p align="center">
  <a href="https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/lists/plain/all.txt"><picture>
    <source width="32%" srcset="assets/btn-download-fr-dark.svg" media="(prefers-color-scheme: dark)">
    <img width="32%" src="assets/btn-download-fr-light.svg" alt="Télécharger la liste">
  </picture></a>
  <a href="docs/INTEGRATION.md"><picture>
    <source width="32%" srcset="assets/btn-plug-fr-dark.svg" media="(prefers-color-scheme: dark)">
    <img width="32%" src="assets/btn-plug-fr-light.svg" alt="Intégrer en 5 minutes">
  </picture></a>
  <a href="mailto:contact@bastivan.com?subject=NexaShield"><picture>
    <source width="32%" srcset="assets/btn-shield-fr-dark.svg" media="(prefers-color-scheme: dark)">
    <img width="32%" src="assets/btn-shield-fr-light.svg" alt="Protéger mon SI">
  </picture></a>
</p>

<picture>
  <source width="100%" srcset="assets/stats-fr-dark.svg" media="(prefers-color-scheme: dark)">
  <img width="100%" src="assets/stats-fr-light.svg" alt="Statistiques : 6126 IP, 72 pays, 476 réseaux, 333747 événements">
</picture>

> [!TIP]
> **Une seule URL pour tous vos pare-feu**, rafraîchie automatiquement :
> `https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/lists/plain/all.txt`

## 💡 Pourquoi nous la publions

NexaShield protège d'abord **notre propre infrastructure**. Chaque heure, il voit passer des robots qui devinent des mots de passe, cherchent des failles connues ou glissent du code malveillant dans des formulaires. Ces mêmes adresses frappent aussi chez vous, souvent sans que personne ne s'en aperçoive.

Garder cette connaissance pour nous n'aurait aucun sens. Alors nous la publions : **gratuitement, sans inscription, sans clé d'API**. Une commande suffit pour que votre pare-feu bloque ce que notre SOC a déjà vu et prouvé.

Et plus il y a de réseaux qui ferment la porte à ces adresses, moins elles rapportent à ceux qui les exploitent. **Chaque blocage compte.**

## ✨ Pourquoi cette liste est différente

- [x] **Des attaques vues, pas des rumeurs** : chaque IP a réellement frappé une infrastructure surveillée par NexaShield. Aucune liste recopiée.
- [x] **Des seuils de preuve** par nature d'attaque, et les faux positifs connus écartés (CDN, moteurs de recherche, scanners de recherche, UDP falsifiable).
- [x] **Signalée à la source** : le contact abuse officiel du réseau reçoit les preuves expurgées avant toute publication.
- [x] **À jour sans intervention** : le SOC vérifie toutes les heures et publie dès qu'une nouvelle attaque est confirmée.
- [x] **Prête à l'emploi** : Fortinet, MikroTik, Cisco, pfSense, OPNsense, Windows, Linux… et Wazuh, CrowdSec, Suricata, OpenCTI, MISP, Splunk, Kubernetes.
- [x] **Rangée pour l'analyse** : pays → réseau (ASN) → IP, avec une fiche lisible et une fiche JSON pour chaque adresse.
- [x] **Zéro donnée client** : ni nom d'hôte, ni adresse cible, ni journal brut.
- [x] **Synthèse rédigée par l'IA**, avec contrôle automatique des chiffres.

## 📊 Votre tableau de bord, chez vous

L'installateur Linux ouvre un **tableau de bord local** sur `http://127.0.0.1:8787` : voyez en direct ce que NexaShield bloque **sur votre machine**.

- 🛡️ **État de la protection** : liste à jour, moteur actif, protégé depuis quand.
- 📈 **Tentatives bloquées** : total, aujourd'hui, par jour et heure par heure.
- 🌍 **Carte des attaquants stoppés chez vous**, avec leur pays, leur réseau et la nature de leurs attaques.
- 🔎 **Recherche** : une IP est-elle listée, et a-t-elle déjà tenté de vous joindre ?

Rien ne sort de votre machine : les compteurs viennent de votre pare-feu, la page n'écoute qu'en local (accès distant par `ssh -L 8787:127.0.0.1:8787 votre-serveur`), et le serveur web tourne sans aucun droit.

## 🚀 Installation en 30 secondes, mise à jour automatique

Les installateurs appliquent le blocage **en entrée et en sortie**, puis **se mettent à jour tout seuls toutes les heures**. Liste d'exceptions locale, garde-fou contre une liste tronquée, désinstallation en une commande.

<details open>
<summary><img src="assets/logos/linux.svg" width="18" height="18" align="center" alt="linux"> <b>Linux</b> (nftables ou ipset + iptables, timer systemd ou cron)</summary>

```bash
curl -fsSLO https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/tools/linux/install.sh
less install.sh          # lisez toujours un script avant de l'exécuter
sudo bash install.sh
```
Tableau de bord : `http://127.0.0.1:8787` · état : `sudo nexashield-blocklist status` · exceptions : `/etc/nexashield/allowlist.txt` · désinstaller : `sudo bash install.sh --uninstall`
</details>

<details>
<summary><img src="assets/logos/windows.svg" width="18" height="18" align="center" alt="windows"> <b>Windows</b> (pare-feu Windows Defender, tâche planifiée)</summary>

PowerShell **administrateur** :
```powershell
$u = "https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/tools/windows"
iwr -UseBasicParsing "$u/Install-NexaShield.ps1" -OutFile Install-NexaShield.ps1
iwr -UseBasicParsing "$u/Update-NexaShieldBlocklist.ps1" -OutFile Update-NexaShieldBlocklist.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .\Install-NexaShield.ps1
```
Exceptions : `C:\ProgramData\NexaShield\allowlist.txt` · désinstaller : `.\Install-NexaShield.ps1 -Uninstall`
</details>

<details>
<summary><img src="assets/logos/mikrotik.svg" width="18" height="18" align="center" alt="mikrotik"> <b>MikroTik RouterOS v7</b> (planificateur, table raw)</summary>

```
/tool fetch url="https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/tools/mikrotik/install.rsc" dst-path=nexashield-install.rsc
/import file-name=nexashield-install.rsc
```
</details>

<details>
<summary><img src="assets/logos/fortinet.svg" width="18" height="18" align="center" alt="fortinet"> <b>Fortinet FortiGate</b> (Threat Feed, rafraîchi par le pare-feu)</summary>

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

Cisco, pfSense, OPNsense, nftables, UFW, nginx, mise à jour planifiée : **[guide complet →](docs/INTEGRATION.md)**

---

## 🤖 Analyse de la menace par l'IA NexaShield

Sur la période observée, 330804 événements ont été recensés depuis 6094 adresses réparties sur 72 pays et 472 réseaux ASN, avec une dernière activité le 2026-11-20. Les principaux pays incluent les États-Unis (2447), le Royaume-Uni (977), les Pays-Bas (565), l'Allemagne (452), la Belgique (356) et la France (286). Les réseaux les plus représentés sont AS25369 Hydra Communications Ltd (977), AS8075 Microsoft Corporation (793), AS396982 Google LLC (444) et AS398324 Censys, Inc. (345).

- Les natures observées incluent le balayage de ports (5661), l'infrastructure botnet / C2 connue (4516), les requêtes HTTP abusives (404), l'exploitation CVE/RCE/injection (315) et la force brute SSH (255)
- On note aussi des charges d'injection bloquées par le WAF (140), des réseaux Spamhaus DROP (60), de la force brute SMTP/IMAP (1) et une signature d'exploit UDP (1)
- Les autres pays du top sont Hong Kong (179) et Andorre (76) ; les réseaux AS43515 Google Ireland Limited (317), AS14618 Amazon.com, Inc. (290), AS135377 UCLOUD INFORMATION TECHNOLOGY HK LIMITED (262) et AS213412 ONYPHE SAS (257) suivent

<sub>Synthèse générée automatiquement le 2026-11-20 par l'IA NexaShield (Mistral AI, modèle européen) à partir des seules statistiques de ce dépôt ; relue par aucun humain avant publication, à titre indicatif.</sub>

---

## 📊 Le paysage de la menace

<table>
<tr>
<td valign="top" width="50%">

#### 🌍 Top pays

| Pays | IP |
|---|---:|
| 🇺🇸 [United States](countries/US_United-States/) | 2459 |
| 🇬🇧 [United Kingdom](countries/GB_United-Kingdom/) | 979 |
| 🇳🇱 [The Netherlands](countries/NL_The-Netherlands/) | 568 |
| 🇩🇪 [Germany](countries/DE_Germany/) | 453 |
| 🇧🇪 [Belgium](countries/BE_Belgium/) | 356 |
| 🇫🇷 [France](countries/FR_France/) | 287 |
| 🇭🇰 [Hong Kong](countries/HK_Hong-Kong/) | 179 |
| 🇦🇩 [Andorra](countries/AD_Andorra/) | 76 |
| 🇨🇳 [China](countries/CN_China/) | 70 |
| 🇸🇬 [Singapore](countries/SG_Singapore/) | 64 |
| 🇯🇵 [Japan](countries/JP_Japan/) | 47 |
| 🇧🇬 [Bulgaria](countries/BG_Bulgaria/) | 46 |
| 🇨🇦 [Canada](countries/CA_Canada/) | 46 |
| 🇸🇪 [Sweden](countries/SE_Sweden/) | 43 |
| 🇧🇷 [Brazil](countries/BR_Brazil/) | 40 |

➡️ [Tous les pays](countries/)

</td>
<td valign="top" width="50%">

#### 🎯 Nature des attaques

| Nature | IP |
|---|---:|
| Balayage de ports | 5685 |
| Infrastructure botnet / C2 connue | 4544 |
| Requêtes HTTP abusives | 409 |
| Exploitation (CVE, RCE, injection) | 315 |
| Force brute SSH | 257 |
| Charge d'injection bloquée par le WAF | 140 |
| Réseau listé Spamhaus DROP | 60 |
| Force brute SMTP / IMAP | 1 |
| Signature d'exploit UDP | 1 |

</td>
</tr>
</table>

#### 🏢 Top réseaux (ASN)

| ASN | Opérateur | Pays (IP) | Total IP |
|---|---|---|---:|
| **AS25369** | Hydra Communications Ltd | [🇬🇧 703](countries/GB_United-Kingdom/AS25369_Hydra-Communications-Ltd/) [🇳🇱 213](countries/NL_The-Netherlands/AS25369_Hydra-Communications-Ltd/) [🇩🇪 63](countries/DE_Germany/AS25369_Hydra-Communications-Ltd/) | 979 |
| **AS8075** | Microsoft Corporation | [🇺🇸 789](countries/US_United-States/AS8075_Microsoft-Corporation/) [🇦🇪 3](countries/AE_United-Arab-Emirates/AS8075_Microsoft-Corporation/) [🇳🇱 2](countries/NL_The-Netherlands/AS8075_Microsoft-Corporation/) [🇿🇦 2](countries/ZA_South-Africa/AS8075_Microsoft-Corporation/) [🇩🇰 1](countries/DK_Denmark/AS8075_Microsoft-Corporation/) [🇮🇪 1](countries/IE_Ireland/AS8075_Microsoft-Corporation/) [🇮🇱 1](countries/IL_Israel/AS8075_Microsoft-Corporation/) [🇮🇳 1](countries/IN_India/AS8075_Microsoft-Corporation/) | 800 |
| **AS396982** | Google LLC | [🇬🇧 200](countries/GB_United-Kingdom/AS396982_Google-LLC/) [🇺🇸 158](countries/US_United-States/AS396982_Google-LLC/) [🇧🇪 49](countries/BE_Belgium/AS396982_Google-LLC/) [🇫🇷 8](countries/FR_France/AS396982_Google-LLC/) [🇩🇪 5](countries/DE_Germany/AS396982_Google-LLC/) [🇰🇷 4](countries/KR_South-Korea/AS396982_Google-LLC/) [🇧🇷 3](countries/BR_Brazil/AS396982_Google-LLC/) [🇯🇵 3](countries/JP_Japan/AS396982_Google-LLC/) [🇦🇺 2](countries/AU_Australia/AS396982_Google-LLC/) [🇨🇦 2](countries/CA_Canada/AS396982_Google-LLC/) [🇮🇳 2](countries/IN_India/AS396982_Google-LLC/) [🇨🇱 1](countries/CL_Chile/AS396982_Google-LLC/) [🇭🇰 1](countries/HK_Hong-Kong/AS396982_Google-LLC/) [🇮🇩 1](countries/ID_Indonesia/AS396982_Google-LLC/) [🇮🇱 1](countries/IL_Israel/AS396982_Google-LLC/) [🇳🇱 1](countries/NL_The-Netherlands/AS396982_Google-LLC/) [🇸🇬 1](countries/SG_Singapore/AS396982_Google-LLC/) [🇹🇭 1](countries/TH_Thailand/AS396982_Google-LLC/) [🇹🇼 1](countries/TW_Taiwan/AS396982_Google-LLC/) | 444 |
| **AS398324** | Censys, Inc. | [🇺🇸 347](countries/US_United-States/AS398324_Censys-Inc/) | 347 |
| **AS43515** | Google Ireland Limited | [🇧🇪 307](countries/BE_Belgium/AS43515_Google-Ireland-Limited/) [🇳🇱 10](countries/NL_The-Netherlands/AS43515_Google-Ireland-Limited/) | 317 |
| **AS14618** | Amazon.com, Inc. | [🇺🇸 290](countries/US_United-States/AS14618_Amazon-com-Inc/) | 290 |
| **AS135377** | UCLOUD INFORMATION TECHNOLOGY (HK) LIMITED | [🇭🇰 73](countries/HK_Hong-Kong/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) [🇺🇸 55](countries/US_United-States/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) [🇹🇭 30](countries/TH_Thailand/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) [🇬🇧 24](countries/GB_United-Kingdom/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) [🇩🇪 15](countries/DE_Germany/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) [🇳🇬 12](countries/NG_Nigeria/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) [🇯🇵 7](countries/JP_Japan/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) [🇰🇷 7](countries/KR_South-Korea/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) [🇹🇼 7](countries/TW_Taiwan/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) [🇵🇭 6](countries/PH_Philippines/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) [🇸🇬 6](countries/SG_Singapore/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) [🇻🇳 6](countries/VN_Vietnam/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) [🇧🇷 5](countries/BR_Brazil/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) [🇦🇪 4](countries/AE_United-Arab-Emirates/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) [🇷🇺 3](countries/RU_Russia/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) [🇮🇳 2](countries/IN_India/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) [🇮🇩 1](countries/ID_Indonesia/AS135377_UCLOUD-INFORMATION-TECHNOLOGY-HK-LIMITED/) | 263 |
| **AS213412** | ONYPHE SAS | [🇫🇷 152](countries/FR_France/AS213412_ONYPHE-SAS/) [🇺🇸 99](countries/US_United-States/AS213412_ONYPHE-SAS/) [🇨🇳 6](countries/CN_China/AS213412_ONYPHE-SAS/) | 257 |
| **AS14061** | DigitalOcean, LLC | [🇺🇸 70](countries/US_United-States/AS14061_DigitalOcean-LLC/) [🇩🇪 30](countries/DE_Germany/AS14061_DigitalOcean-LLC/) [🇸🇬 18](countries/SG_Singapore/AS14061_DigitalOcean-LLC/) [🇬🇧 16](countries/GB_United-Kingdom/AS14061_DigitalOcean-LLC/) [🇳🇱 14](countries/NL_The-Netherlands/AS14061_DigitalOcean-LLC/) [🇦🇺 9](countries/AU_Australia/AS14061_DigitalOcean-LLC/) [🇮🇳 6](countries/IN_India/AS14061_DigitalOcean-LLC/) [🇨🇦 5](countries/CA_Canada/AS14061_DigitalOcean-LLC/) | 168 |
| **AS45102** | Alibaba (US) Technology Co., Ltd. | [🇺🇸 58](countries/US_United-States/AS45102_Alibaba-US-Technology-Co-Ltd/) [🇩🇪 33](countries/DE_Germany/AS45102_Alibaba-US-Technology-Co-Ltd/) [🇸🇬 28](countries/SG_Singapore/AS45102_Alibaba-US-Technology-Co-Ltd/) [🇯🇵 21](countries/JP_Japan/AS45102_Alibaba-US-Technology-Co-Ltd/) [🇲🇾 17](countries/MY_Malaysia/AS45102_Alibaba-US-Technology-Co-Ltd/) [🇵🇭 1](countries/PH_Philippines/AS45102_Alibaba-US-Technology-Co-Ltd/) | 158 |

---

## 🔧 Compatible avec votre équipement

| Équipement | Fichier / méthode |
|---|---|
| <img src="assets/logos/fortinet.svg" width="22" height="22" align="center" alt="fortinet"> **Fortinet FortiGate** | Threat Feed (External Connector) → [`lists/plain/all.txt`](lists/plain/all.txt) |
| <img src="assets/logos/mikrotik.svg" width="22" height="22" align="center" alt="mikrotik"> **MikroTik RouterOS** | installateur [`tools/mikrotik/install.rsc`](tools/mikrotik/install.rsc) · liste [`lists/mikrotik.rsc`](lists/mikrotik.rsc) |
| <img src="assets/logos/cisco.svg" width="22" height="22" align="center" alt="cisco"> **Cisco ASA / IOS / FTD** | [`lists/cisco-asa.txt`](lists/cisco-asa.txt) · [`lists/cisco-ios.txt`](lists/cisco-ios.txt) · flux Security Intelligence FMC |
| <img src="assets/logos/pfsense.svg" width="22" height="22" align="center" alt="pfsense"> **pfSense** (et pfBlockerNG) | Alias *URL Table (IPs)* → [`lists/plain/all.txt`](lists/plain/all.txt) |
| <img src="assets/logos/opnsense.svg" width="22" height="22" align="center" alt="opnsense"> **OPNsense** | Alias *URL Table (IPs)* → [`lists/plain/all.txt`](lists/plain/all.txt) |
| <img src="assets/logos/windows.svg" width="22" height="22" align="center" alt="windows"> **Windows** | installateur [`tools/windows/Install-NexaShield.ps1`](tools/windows/Install-NexaShield.ps1) (tâche planifiée) |
| <img src="assets/logos/linux.svg" width="22" height="22" align="center" alt="linux"> **Linux** | installateur [`tools/linux/install.sh`](tools/linux/install.sh) (nftables / ipset) · UFW → [`lists/plain/all.txt`](lists/plain/all.txt) |
| <img src="assets/logos/nginx.svg" width="22" height="22" align="center" alt="nginx"> **nginx** | [`lists/nginx-deny.conf`](lists/nginx-deny.conf) |
| <img src="assets/logos/paloaltonetworks.svg" width="22" height="22" align="center" alt="paloaltonetworks"> **Autres** (Palo Alto, Stormshield, Sophos, Check Point…) | toute liste d'adresses par URL → [`lists/plain/all.txt`](lists/plain/all.txt) |

Pour un SIEM ou une analyse : [`lists/abuse-ip.csv`](lists/abuse-ip.csv) · [`lists/abuse-ip.json`](lists/abuse-ip.json) (pays, ASN, natures, dates).

---

## 🧩 Branché sur vos logiciels

| SIEM et détection | Renseignement (CTI) | Web et conteneurs |
|---|---|---|
| **Wazuh** (liste CDB) · [`wazuh-cdb.txt`](lists/wazuh-cdb.txt) | **OpenCTI** · **MISP** · **Sentinel** · [`stix2-bundle.json`](lists/stix2-bundle.json) | **Apache** · [`apache-deny.conf`](lists/apache-deny.conf) |
| **CrowdSec** · [`crowdsec-decisions.json`](lists/crowdsec-decisions.json) | Identifiants STIX 2.1 stables : pas de doublon | **HAProxy** · **Cloudflare** · **Proxmox VE** |
| **Suricata / Snort 3** · [`suricata.rules`](lists/suricata.rules) | | **Kubernetes / Cilium** · [`cilium-clusterwide-deny.yaml`](lists/kubernetes/cilium-clusterwide-deny.yaml) |
| **Splunk** · **Elastic** · **Graylog** · [`abuse-ip.csv`](lists/abuse-ip.csv) | | **Docker** (via l'installateur Linux) |

Pas à pas pour chaque logiciel : **[docs/SOFTWARE.md](docs/SOFTWARE.md)**

---

## 🧠 Derrière cette liste : NexaShield

Cette liste n'est qu'un sous-produit. **NexaShield** est la plateforme de détection et de réponse de [Bastivan Consulting](https://bastivan.com) : quatre couches qui se parlent entre elles.

| | Couche | Ce qu'elle fait pour vous |
|:-:|---|---|
| 🖥️ | **EDR** · *Endpoint Detection & Response* | Surveille chaque poste et serveur (Linux, Windows, macOS, conteneurs Kubernetes) : processus, intégrité des fichiers, persistance, élévation de privilèges, logiciels malveillants mis en quarantaine automatiquement. |
| 🌐 | **NDR** · *Network Detection & Response* | Analyse le trafic réseau en continu : signatures d'exploitation, balayages, DNS suspect, *beaconing*, connexions vers des infrastructures malveillantes connues. |
| 🔗 | **XDR** · *Extended Detection & Response* | Corrèle en temps réel les signaux EDR, NDR, web, authentification et messagerie pour reconstituer **le déroulé complet d'une attaque**, pas seulement une alerte isolée. |
| 👁️ | **MDR** · *Managed Detection & Response* | Notre SOC (gestion de cas, renseignement sur les menaces, enrichissement automatique des IOC) veille, qualifie et répond pour vous. |

- 🚫 **Réponse automatique en quelques secondes** : bannissement de l'attaquant, coupure de session, isolation d'un conteneur compromis, quarantaine de fichier.
- 🧬 **Renseignement intégré** : flux publics, partage d'IOC, enrichissement RIPE / GeoIP de chaque adresse.
- 📨 **Signalement d'abus automatisé** aux hébergeurs, preuves à l'appui.
- 📊 **Rapports prêts pour l'audit**, alignés sur **NIS2** et **DORA**, mappés sur **MITRE ATT&CK**.
- 🇫🇷 **Souverain** : conçu, hébergé et opéré en France.

### 🆚 La liste gratuite… ou NexaShield sur votre infrastructure

| | Cette liste | NexaShield |
|---|:-:|:-:|
| Bloquer les IP déjà vues par notre SOC | ✅ | ✅ |
| Détecter les attaques qui visent **vos** postes, serveurs et conteneurs | ❌ | ✅ |
| Analyser **votre** trafic réseau (exploitation, DNS, *beaconing*) | ❌ | ✅ |
| Reconstituer le déroulé complet d'une attaque | ❌ | ✅ |
| Bannir, couper, isoler, mettre en quarantaine automatiquement | ❌ | ✅ |
| Un SOC qui qualifie vos alertes et vous accompagne | ❌ | ✅ |
| Rapports prêts pour l'audit **NIS2 / DORA** | ❌ | ✅ |

<p align="center">
  <a href="mailto:contact@bastivan.com?subject=NexaShield"><img src="https://img.shields.io/badge/Protéger%20mon%20infrastructure-contact%40bastivan.com-dc2626?style=for-the-badge&labelColor=080f12" alt="Contact"></a>
  <a href="https://bastivan.com"><img src="https://img.shields.io/badge/Site-bastivan.com-2563eb?style=for-the-badge&labelColor=080f12" alt="bastivan.com"></a>
</p>

---

## ✅ Comment une IP arrive ici

<details>
<summary>Les six portes de preuve</summary>

1. **Attaque réelle entrante** observée par NexaShield (jamais une simple réputation).
2. **Seuil de preuve** par nature : 1 contact C2, 2 exploitations, 5 requêtes web malveillantes, 10 échecs SSH.
3. **Au moins un événement applicatif** : un simple balayage de ports ne suffit pas.
4. **Faux positifs écartés** : CDN, moteurs de recherche, sociétés de scan connues, trafic UDP (falsifiable), clients légitimes ayant réussi à se connecter.
5. **Signalement d'abus** envoyé au contact officiel du réseau (RIPEstat).
6. **Publication** ici, classée par pays, réseau et adresse.

S'y ajoutent les adresses **bannies définitivement** par NexaShield sans signalement à l'hébergeur (récidive, petites attaques persistantes jugées par l'IA, campagne confirmée) : leur fiche porte la mention « not reported (permanent ban) ».
</details>

## 📂 Organisation du dépôt

<details>
<summary>Arborescence</summary>

```
countries/
└── <CODE-PAYS>_<Pays>/                  ← un dossier par pays (README avec les réseaux)
    └── AS<numéro>_<Opérateur>/          ← un dossier par réseau (README avec les IP)
        └── <IP>/                        ← un dossier par adresse
            ├── README.md                ← fiche lisible
            └── ip.json                  ← fiche machine
analysis/latest.md                       ← synthèse de la menace par l'IA NexaShield (Mistral)
bans/
├── permaban.txt                         ← tous les bannissements définitifs, avec en-tête (mise à jour horaire)
└── plain/all.txt · ipv4.txt · ipv6.txt  ← une entrée par ligne (IP ou plage CIDR)
lists/
├── plain/all.txt · ipv4.txt · ipv6.txt  ← une IP par ligne, sans commentaire (flux URL)
├── blocklist.txt                        ← toutes les IP, avec en-tête
├── mikrotik.rsc                         ← MikroTik RouterOS
├── cisco-asa.txt · cisco-ios.txt        ← Cisco
├── nginx-deny.conf · apache-deny.conf   ← nginx, Apache
├── wazuh-cdb.txt · crowdsec-decisions.json · suricata.rules ← SIEM / IDS
├── stix2-bundle.json                    ← STIX 2.1 (OpenCTI, MISP, Sentinel)
├── kubernetes/                          ← Cilium
└── abuse-ip.csv · abuse-ip.json         ← tableau complet (pays, ASN, natures, dates)
docs/INTEGRATION.md · SOFTWARE.md       ← guides équipements et logiciels
dashboard/                               ← tableau de bord (installé en local par tools/linux)
tools/linux/install.sh                   ← installateur Linux (mise à jour toutes les heures)
tools/windows/                           ← installateur et script PowerShell
tools/mikrotik/install.rsc               ← installateur RouterOS
CONTRIBUTING.md · SECURITY.md · CODE_OF_CONDUCT.md
```

Dans les noms de dossier IPv6, les `:` sont remplacés par `_` (compatibilité Windows).
</details>

## 🚫 Bannissements définitifs (liste étendue)

En plus des adresses signalées ci-dessus, NexaShield publie **toutes** les adresses qu'il a bannies définitivement sur l'infrastructure de Bastivan Consulting : récidive, petites attaques persistantes jugées par l'IA, campagnes confirmées. Mise à jour automatique toutes les heures.

<!-- BANS:START -->
**5063** adresses bannies définitivement (**5005** IP, **58** plages CIDR), mises à jour toutes les heures : [`bans/permaban.txt`](bans/permaban.txt) (commentée) · [`bans/plain/all.txt`](bans/plain/all.txt) (flux pare-feu) · [`ipv4`](bans/plain/ipv4.txt) / [`ipv6`](bans/plain/ipv6.txt).
<!-- BANS:END -->

> Ces adresses n'ont pas toutes été signalées à leur hébergeur : pour un blocage strictement « signalé et prouvé », préférez [`lists/`](lists/).

## ⚠️ Avertissement

- Une IP listée est souvent une **machine compromise** ou un serveur loué à la minute : son propriétaire n'est pas forcément l'attaquant.
- Les adresses changent de main : utilisez ces données avec une **durée de vie limitée** et à vos risques. Testez d'abord en journalisation.
- **Retrait / contestation** : écrivez à [contact@bastivan.com](mailto:contact@bastivan.com) en précisant l'adresse IP ; nous traitons chaque demande.

## 🤝 Communauté

- 🔌 Un équipement manque au guide ? **[Contribuez](CONTRIBUTING.md)**.
- 🗑️ Une IP listée à tort ? **[Demande de retrait](https://github.com/bastivanconsulting/Nexashield-Abuse-IP/issues/new?template=removal-request.yml)**.
- 🔐 Une faille dans un script ? **[Politique de sécurité](SECURITY.md)**, jamais en public.
- 🧭 Des échanges respectueux : **[Code de conduite](CODE_OF_CONDUCT.md)**.

## ⭐ Soutenir le projet

Si cette liste protège votre réseau, **une étoile** aide d'autres administrateurs à la trouver.

<a href="https://star-history.com/#bastivanconsulting/Nexashield-Abuse-IP&Date">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=bastivanconsulting/Nexashield-Abuse-IP&type=Date&theme=dark">
    <img width="100%" alt="Historique des étoiles" src="https://api.star-history.com/svg?repos=bastivanconsulting/Nexashield-Abuse-IP&type=Date">
  </picture>
</a>

## 📜 Licence et attribution

- Données et scripts publiés sous **[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)** : citez « NexaShield Abuse IP, Bastivan Consulting ».
- IP geolocation by **[DB-IP](https://db-ip.com)** (CC BY 4.0).
- Propriétaires et contacts abuse : **[RIPEstat](https://stat.ripe.net)**.
- Logos d'équipements : [Simple Icons](https://simpleicons.org) (CC0). Les marques citées appartiennent à leurs propriétaires ; elles indiquent uniquement la compatibilité.

---

<div align="center">

**🛡️ NexaShield** · *Détecter. Corréler. Répondre.*

© 2026 [Bastivan Consulting SAS](https://bastivan.com) · Conseil, infogérance, cloud et cybersécurité · Beauvais, France

</div>
