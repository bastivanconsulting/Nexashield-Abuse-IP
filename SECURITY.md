# 🔐 Politique de sécurité / Security Policy

[Français](#-français) · [English](#-english)

## 🇫🇷 Français

### Ce qui est couvert

| Périmètre | Exemples |
|---|---|
| **Scripts d'installation et de mise à jour** | `tools/linux/install.sh`, `tools/windows/*.ps1`, `tools/mikrotik/install.rsc` : injection de commande, élévation de privilèges, téléchargement non vérifié |
| **Intégrité des listes** | IP légitime publiée à tort, possibilité d'empoisonner la liste, format pouvant casser un équipement |
| **Fuite de données** | toute information sur nos clients ou notre infrastructure présente dans ce dépôt (il ne doit y en avoir aucune) |

### Signaler une vulnérabilité

**N'ouvrez pas d'issue publique.** Écrivez à **[security@bastivan.com](mailto:security@bastivan.com)** avec :

1. la description du problème et son impact ;
2. les étapes pour le reproduire (fichier, ligne, commande) ;
3. vos coordonnées si vous souhaitez être cité.

Nous accusons réception, analysons, corrigeons, puis vous tenons informé. Nous remercions publiquement les chercheurs qui le souhaitent une fois le correctif publié.

### Divulgation responsable

Merci de nous laisser le temps de corriger avant toute publication, et de ne pas tester sur des systèmes qui ne vous appartiennent pas. Aucun test d'intrusion ne doit viser l'infrastructure de Bastivan Consulting ou de ses clients sans accord écrit préalable.

### Une IP listée à tort ?

Ce n'est pas une vulnérabilité : utilisez le formulaire **[Demande de retrait](https://github.com/bastivanconsulting/Nexashield-Abuse-IP/issues/new?template=removal-request.yml)** ou écrivez à [contact@bastivan.com](mailto:contact@bastivan.com).

---

## 🇬🇧 English

### Scope

- **Install and update scripts** (`tools/`): command injection, privilege escalation, unverified downloads.
- **List integrity**: legitimate IP wrongly listed, list poisoning, output that could break a device.
- **Data leaks**: any information about our customers or infrastructure (there must be none).

### Reporting a vulnerability

**Please do not open a public issue.** Email **[security@bastivan.com](mailto:security@bastivan.com)** with a description, impact and reproduction steps. We will acknowledge, investigate, fix and keep you informed, and credit you publicly if you wish.

Please give us time to fix before disclosure, and never test against systems you do not own. Penetration testing of Bastivan Consulting's or its customers' infrastructure requires prior written approval.

Wrongly listed IP? Use the **[removal request](https://github.com/bastivanconsulting/Nexashield-Abuse-IP/issues/new?template=removal-request.yml)** form or email [contact@bastivan.com](mailto:contact@bastivan.com).
