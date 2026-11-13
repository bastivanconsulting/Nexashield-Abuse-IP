# 🧩 Brancher NexaShield sur vos logiciels

Pare-feu, c'est le [guide d'intégration](INTEGRATION.md). Ici : **SIEM, IDS, plateformes de renseignement, serveurs web, orchestrateurs et outils de sécurité**. Tous les fichiers sont régénérés automatiquement à chaque nouvelle attaque confirmée.

Base des URL : `https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/`

| Logiciel | Fichier | Usage |
|---|---|---|
| **Wazuh** | [`lists/wazuh-cdb.txt`](../lists/wazuh-cdb.txt) | liste CDB pour vos règles |
| **CrowdSec** | [`lists/crowdsec-decisions.json`](../lists/crowdsec-decisions.json) | décisions de bannissement |
| **Suricata / Snort 3** | [`lists/suricata.rules`](../lists/suricata.rules) | règles IDS / IPS |
| **OpenCTI, MISP, Microsoft Sentinel, tout outil STIX** | [`lists/stix2-bundle.json`](../lists/stix2-bundle.json) | indicateurs STIX 2.1 |
| **Splunk, Elastic, Graylog, Grafana** | [`lists/abuse-ip.csv`](../lists/abuse-ip.csv) · [`.json`](../lists/abuse-ip.json) | enrichissement, tableaux de bord |
| **Kubernetes (Cilium ≥ 1.15)** | [`lists/kubernetes/cilium-clusterwide-deny.yaml`](../lists/kubernetes/cilium-clusterwide-deny.yaml) | refus en entrée et en sortie |
| **Apache 2.4** | [`lists/apache-deny.conf`](../lists/apache-deny.conf) | `Require not ip` |
| **nginx** | [`lists/nginx-deny.conf`](../lists/nginx-deny.conf) | `deny` |
| **HAProxy, Proxmox VE, Cloudflare, Docker** | [`lists/plain/all.txt`](../lists/plain/all.txt) | voir ci-dessous |

> ⚠️ Commencez en **détection** (alerte, journalisation) avant de bloquer, et gardez une liste d'exceptions pour vos partenaires.

---

## 🛡️ SIEM et détection

### Wazuh
```bash
curl -fsSL -o /var/ossec/etc/lists/nexashield-abuse \
  https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/lists/wazuh-cdb.txt
chown wazuh:wazuh /var/ossec/etc/lists/nexashield-abuse
```
Dans `ossec.conf`, section `<ruleset>` : `<list>etc/lists/nexashield-abuse</list>`. Puis une règle (fichier `local_rules.xml`) :
```xml
<group name="nexashield,threat_intel,">
  <rule id="100900" level="10">
    <if_level>3</if_level>
    <list field="srcip" lookup="address_match_key">etc/lists/nexashield-abuse</list>
    <description>NexaShield Abuse IP : activité d'une IP attaquante connue ($(srcip))</description>
    <mitre><id>T1595</id></mitre>
  </rule>
</group>
```
Testez avec `wazuh-logtest`, puis redémarrez le manager. Adaptez l'ID à votre plage de règles locales.

### CrowdSec
```bash
curl -fsSL -o /tmp/nexashield.json \
  https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/lists/crowdsec-decisions.json
cscli decisions import -i /tmp/nexashield.json
```
Les décisions durent 72 h : planifiez l'import (cron toutes les 6 h) et vos *bouncers* appliquent le blocage partout.

### Suricata / Snort 3
```bash
curl -fsSL -o /var/lib/suricata/rules/nexashield.rules \
  https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/lists/suricata.rules
```
Ajoutez `nexashield.rules` à `rule-files` dans `suricata.yaml`, vérifiez avec `suricata -T`, puis rechargez (`suricatasc -c reload-rules`). Avec **suricata-update** : `suricata-update add-source nexashield https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/lists/suricata.rules`. Les règles sont en `alert` ; passez-les en `drop` en mode IPS. SID réservés : 1980000 à 1980099.

### Splunk
Téléchargez [`abuse-ip.csv`](../lists/abuse-ip.csv) comme *lookup* (`nexashield_abuse.csv`), puis :
```
index=* src_ip=* | lookup nexashield_abuse.csv ip AS src_ip OUTPUT country asn_org categories
| where isnotnull(categories)
```

### Elastic
Indexez le CSV ou le JSON (Kibana › *Upload a file*, ou Logstash `http_poller`), créez une *enrich policy* sur le champ `ip`, puis un *ingest pipeline* `enrich` sur `source.ip`. Les correspondances sont alors visibles dans tous vos tableaux de bord.

### Graylog
*System › Lookup Tables › Data Adapters* : type **DSV File from HTTP**, URL de `lists/plain/all.txt`, intervalle de rafraîchissement 3600 s, séparateur de ligne `\n`, clé = valeur. Créez le cache et la table `nexashield_abuse`, puis utilisez `lookup_value("nexashield_abuse", to_string($message.src_ip))` dans une règle de pipeline.

---

## 🧬 Renseignement sur les menaces (CTI)

### OpenCTI
*Données › Import* : déposez [`stix2-bundle.json`](../lists/stix2-bundle.json). Les identifiants STIX sont **stables** : un nouvel import met à jour les indicateurs existants au lieu de les dupliquer. Pour un flux automatique, utilisez *Ingestion › Flux CSV* sur `lists/plain/all.txt`.

### MISP
*Sync Actions › Feeds › Add Feed* : format **Freetext Parsed**, URL `lists/plain/all.txt`, activez *Caching* et *Lookup visible*. Les correspondances apparaissent sur vos événements. Le fichier STIX 2.1 peut aussi être importé dans un événement.

### Microsoft Sentinel
*Threat intelligence › Import › Import using a file* : format **STIX**, fichier [`stix2-bundle.json`](../lists/stix2-bundle.json). Les indicateurs alimentent les règles analytiques « TI map IP entity ».

---

## 🌐 Serveurs web et répartiteurs

### Apache 2.4
```bash
curl -fsSL -o /etc/apache2/conf-available/nexashield-deny.conf \
  https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/lists/apache-deny.conf
```
Incluez le fichier dans un `<Location />` ou `<Directory>` (`Include conf-available/nexashield-deny.conf`), puis `apachectl configtest && systemctl reload apache2`.

### HAProxy
```bash
curl -fsSL -o /etc/haproxy/nexashield.lst \
  https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/lists/plain/all.txt
```
Dans le `frontend` : `tcp-request connection reject if { src -f /etc/haproxy/nexashield.lst }`, puis `haproxy -c -f /etc/haproxy/haproxy.cfg && systemctl reload haproxy`.

### Cloudflare
Créez une liste d'IP (*Manage Account › Configurations › Lists*), puis remplacez son contenu (IPv4) avec un jeton API limité à *Account Filter Lists: Edit* :
```bash
curl -fsSL https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/lists/plain/ipv4.txt \
  | jq -R '{ip: .}' | jq -s . \
  | curl -fsS -X PUT "https://api.cloudflare.com/client/v4/accounts/$CF_ACCOUNT_ID/rules/lists/$CF_LIST_ID/items" \
      -H "Authorization: Bearer $CF_API_TOKEN" -H "Content-Type: application/json" --data @-
```
Utilisez ensuite la liste dans une règle WAF (`ip.src in $nexashield_abuse` → *Block*). Le jeton se lit depuis votre coffre de secrets, jamais en clair dans un script.

---

## ☸️ Conteneurs et virtualisation

### Kubernetes avec Cilium (≥ 1.15)
```bash
kubectl apply --dry-run=server -f https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/lists/kubernetes/cilium-clusterwide-deny.yaml
```
La politique ne contient **que des refus** et `enableDefaultDeny: false` : elle ne change rien aux autres flux. En GitOps (Flux, Argo CD), versionnez le fichier dans votre dépôt et mettez-le à jour par une tâche planifiée plutôt que de l'appliquer depuis Internet.

### Docker
L'[installateur Linux](../tools/linux/install.sh) filtre aussi la chaîne *forward* : les conteneurs publiés sont protégés sans configuration supplémentaire.

### Proxmox VE
```bash
pvesh create /cluster/firewall/ipset --name nexashield --comment "NexaShield Abuse IP" 2>/dev/null || true
for ip in $(curl -fsSL https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/lists/plain/all.txt); do
  pvesh create /cluster/firewall/ipset/nexashield --cidr "$ip" 2>/dev/null || true
done
```
Puis une règle de centre de données : *Datacenter › Firewall › Add* : direction **in**, action **DROP**, source `+nexashield`.

---

<div align="center">

**Vous voulez que ces attaques soient détectées et bloquées sur votre propre infrastructure, avec un SOC qui s'en occupe ?**
🛡️ **NexaShield EDR · XDR · NDR · MDR** · 📧 [contact@bastivan.com](mailto:contact@bastivan.com) · 🌍 [bastivan.com](https://bastivan.com)

</div>
