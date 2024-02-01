# Documentation de l'application EventFlow

## I. Présentation Technique du Projet

### Fiche d'Identité Synthétique
- **Nom du Projet:** EventFlow
- **Type du Projet:** Application mobile de réservation de tickets d'évènements
- **Objet du Projet:** Faciliter la réservation de tickets pour des occasions de divertissements
- **Support:** Smartphone Android
- **Fonctionnalité:** EventFlow permet l'achat de billets pour divers événements et autorise la création d'événements par les utilisateurs.

### Cadre Logique du Projet
- **Objectif:** Évaluation du niveau d’assimilation des connaissances acquises dans l'UE Développement Mobile Flutter.
- **Résultats Attendus:** Développement et hébergement d'une application mobile fonctionnelle de réservation de tickets d’évènements.
- **Activités:** Répartition des tâches entre membres développeurs et designers.

### Environnements de Développement
- **Framework de Développement:** Flutter
- **Base de Données | Back-end:** Firebase Database
- **Système de Paiement:** Kkiapay
- **Stockage de Fichiers:** Firebase Cloud Messaging
- **Test et Déploiement:** Android
- **Design et Maquettage:** Figma

## II. Charte Graphique

### Couleurs
- Jaune Clair: #FFFF40 (HEX)
- Noir Raisin: #252323
- Bleu Roi: #0000BB

### Police
- Police par défaut de Flutter

### Maquette de l'Interface
[Lien vers la maquette Figma](https://www.figma.com/file/V8scI3RQb2d6Nkln3ZKH1W/EventFlow?type=design&node-id=0%3A1&mode=design&t=MuZRyWqvD9dHwQ8z-1)

## III. Utilisateurs et Droits d'Accès

L'application est conçue pour trois catégories d'utilisateurs :

1. **Utilisateurs Classiques:**
   - Accès aux événements existants.
   - Achat de tickets.

2. **Organisateurs:**
   - Création d'événements (doit être validée par un administrateur).
   - Scan des codes QR pour confirmer l'identité des participants.
   - Possibilité de devenir administrateur pendant la phase de test.

3. **Administrateurs:**
   - Validation des événements créés par les organisateurs.
   - Création d'événements visibles directement sur la page d'accueil.

## IV. Processus Utilisateur

### Connexion et Achat de Tickets
1. Connexion avec un compte Google.
2. Redirection vers la page d'accueil en tant qu'utilisateur classique.
3. Visualisation des événements disponibles à l'achat.
4. Cliquez sur un événement pour voir les détails et achetez un ticket.

### Validation d'un Événement (Fonctionnalité Administrateur)
1. Dans la section "Compte", cliquez sur "Valider les événements".
2. Liste des événements à valider.
3. Cliquez sur la partie jaune d'un événement pour voir les détails avant de valider.

### Compilation de l'Application sur un Émulateur Android
1. Assurez-vous qu'ADB est installé.
2. Placez le fichier app-debug.apk dans le répertoire d'installation.
3. Connectez l'appareil ou lancez l'émulateur.
4. Dans le terminal Ubuntu, déplacez-vous vers le dossier du fichier app-debug.apk.
5. Exécutez `adb install app-debug.apk`.

## V. Conclusion
En résumé, ces instructions simples guident l'utilisation de l'application EventFlow. Si vous quittez l'application sans vous déconnecter, elle vous redirigera automatiquement vers la page d'accueil lors de la prochaine connexion.

## VI. Lien du Dépôt GitHub
[EventFlow sur GitHub](https://github.com/deodat04/EventFlow-Mobile_App)
