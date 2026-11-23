# Liste des bannissements définitifs NexaShield

Toutes les adresses **bannies définitivement** par NexaShield sur l'infrastructure de Bastivan Consulting, mise à jour automatiquement toutes les heures (date dans l'en-tête de [`permaban.txt`](permaban.txt)).

- **6196** entrées : **6121** IP et **75** plages CIDR (une /24 n'est bannie qu'après plus de 100 IP hostiles vues dans la plage).
- Contrairement à [`lists/`](../lists/), ces adresses n'ont pas toutes fait l'objet d'un signalement à leur hébergeur : elles ont été bannies sur détection automatique répétée (récidive, persistance sur plusieurs jours, campagne confirmée).
- Adresses privées ou réservées, infrastructure Bastivan et listes d'exception retirées avant publication.

| Fichier | Contenu |
|---|---|
| [`permaban.txt`](permaban.txt) | liste commentée |
| [`plain/all.txt`](plain/all.txt) | une entrée par ligne, sans commentaire (flux URL de pare-feu) |
| [`plain/ipv4.txt`](plain/ipv4.txt) / [`plain/ipv6.txt`](plain/ipv6.txt) | par famille d'adresses |

Retrait d'une adresse : contact@bastivan.com.
