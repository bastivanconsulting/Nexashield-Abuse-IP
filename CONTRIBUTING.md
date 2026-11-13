# 🤝 Contribuer / Contributing

[Français](#-français) · [English](#-english)

Merci de vouloir améliorer NexaShield Abuse IP ! Chaque contribution aide des administrateurs à protéger leur réseau.

## 🇫🇷 Français

### ⚠️ Les données sont générées automatiquement

Les dossiers `countries/`, `lists/`, `analysis/` et les fichiers `README*.md` sont **régénérés par le SOC NexaShield à chaque publication**. Une pull request qui les modifie sera écrasée. Pour faire **ajouter** une IP, elle doit avoir attaqué une infrastructure protégée par NexaShield : nous ne publions pas d'IP signalées par des tiers. Pour en faire **retirer** une, voir plus bas.

### ✅ Contributions bienvenues

| Sujet | Où |
|---|---|
| Guide pour un nouvel équipement (Stormshield, Sophos, Palo Alto, Ubiquiti, Juniper…) | `docs/INTEGRATION.md` |
| Amélioration des installateurs | `tools/linux`, `tools/windows`, `tools/mikrotik` |
| Nouveau format de liste utile | ouvrez d'abord une **issue** pour en discuter |
| Correction, traduction, clarté de la documentation | tout fichier `.md` hors données |

### 🗑️ Demander le retrait d'une IP

Formulaire **[Demande de retrait](https://github.com/bastivanconsulting/Nexashield-Abuse-IP/issues/new?template=removal-request.yml)**, ou e-mail à [contact@bastivan.com](mailto:contact@bastivan.com) si vous préférez ne pas publier votre demande. Chaque demande est examinée ; une IP retirée n'est plus republiée.

### 🔀 Proposer une modification

1. Forkez le dépôt et créez une branche (`docs/stormshield`, `fix/install-ipset`…).
2. Faites des commits courts et explicites, en français ou en anglais.
3. Pour un script : testez-le sur une machine de test, jamais directement en production, et décrivez le test dans la pull request.
4. Ouvrez la pull request en remplissant le modèle.

### 🧭 Règles

- **Sécurité d'abord** : aucun script ne doit désactiver un pare-feu, élargir des droits ou télécharger sans HTTPS.
- **Aucune donnée personnelle ni secret** dans une contribution.
- Respect du **[Code de conduite](CODE_OF_CONDUCT.md)**.
- Une faille ? Ne l'ouvrez pas en public : **[SECURITY.md](SECURITY.md)**.

---

## 🇬🇧 English

- **Data is generated automatically**: `countries/`, `lists/`, `analysis/` and `README*.md` are rebuilt by the NexaShield SOC on every publication; pull requests touching them will be overwritten. We only publish IPs that attacked infrastructure protected by NexaShield, never third-party reports.
- **Welcome**: integration guides for new devices (`docs/INTEGRATION.md`), installer improvements (`tools/`), documentation fixes and translations. Open an issue first for new list formats.
- **Removal request**: use the [removal form](https://github.com/bastivanconsulting/Nexashield-Abuse-IP/issues/new?template=removal-request.yml) or email [contact@bastivan.com](mailto:contact@bastivan.com).
- **Workflow**: fork, branch, short clear commits (EN or FR), test scripts on a non-production machine, open a pull request using the template.
- **Rules**: security first, no personal data or secrets, follow the [Code of Conduct](CODE_OF_CONDUCT.md), report vulnerabilities privately ([SECURITY.md](SECURITY.md)).
