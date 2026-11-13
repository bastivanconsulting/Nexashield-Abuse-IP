# NexaShield Abuse IP - installateur MikroTik RouterOS v7 / RouterOS v7 installer
# Import : /tool fetch url="https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/tools/mikrotik/install.rsc" dst-path=nexashield-install.rsc
#          /import file-name=nexashield-install.rsc
# Effet : liste d'adresses "nexashield-abuse" mise à jour toutes les heures + blocage dans la table raw (IPv4 et IPv6).
# Désinstaller : /system scheduler remove [find name=nexashield-abuse]
#                /ip firewall raw remove [find comment="NexaShield abuse IP"]
#                /ipv6 firewall raw remove [find comment="NexaShield abuse IP"]
#                /ip firewall address-list remove [find list=nexashield-abuse]
#                /ipv6 firewall address-list remove [find list=nexashield-abuse]
# NexaShield EDR · XDR · NDR · MDR - Bastivan Consulting - https://bastivan.com

/system scheduler remove [find name=nexashield-abuse]
/system scheduler add name=nexashield-abuse interval=1h start-time=startup policy=read,write,policy,test \
    on-event=":do { /tool fetch url=\"https://raw.githubusercontent.com/bastivanconsulting/Nexashield-Abuse-IP/main/lists/mikrotik.rsc\" dst-path=nexashield.rsc; :delay 5s; /import file-name=nexashield.rsc; /file remove [find name=nexashield.rsc] } on-error={ :log warning \"NexaShield: mise a jour impossible\" }"

/ip firewall raw remove [find comment="NexaShield abuse IP"]
:if ([:len [/ip firewall raw find]] > 0) do={ /ip firewall raw add chain=prerouting src-address-list=nexashield-abuse action=drop comment="NexaShield abuse IP" place-before=0 } else={ /ip firewall raw add chain=prerouting src-address-list=nexashield-abuse action=drop comment="NexaShield abuse IP" }
/ipv6 firewall raw remove [find comment="NexaShield abuse IP"]
:if ([:len [/ipv6 firewall raw find]] > 0) do={ /ipv6 firewall raw add chain=prerouting src-address-list=nexashield-abuse action=drop comment="NexaShield abuse IP" place-before=0 } else={ /ipv6 firewall raw add chain=prerouting src-address-list=nexashield-abuse action=drop comment="NexaShield abuse IP" }

/system scheduler run [find name=nexashield-abuse]
:log info "NexaShield Abuse IP installe : mise a jour toutes les heures"
