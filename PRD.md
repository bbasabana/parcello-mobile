# PRD Complet - Application Mobile Parcello (Flutter)

## 1. Vision et Objectifs
L'application mobile Parcello est l'extension de terrain indispensable pour les **Chefs de Quartier**. Elle remplace les formulaires papier par une saisie numérique géo-référencée, permettant un recensement en temps réel des parcelles et de leurs occupants dans la ville de Kinshasa.

## 2. Parcours Utilisateur & Menu (Sidebar)
L'application mobile doit refléter exactement les rubriques du dashboard web :

1.  **Vue d'ensemble** : Dashboard avec compteurs (Nombre de parcelles, Propriétaires, Résidents recensés, Liens publics générés).
2.  **Mes Parcelles** : Liste chronologique des fiches créées avec leur statut (En attente d'approbation, Approuvé, Correction requise).
3.  **Cartographie** : Visualisation GPS de toutes les parcelles du quartier sur une carte interactive.
4.  **MAPA Data** : Consultation des données de référence.
5.  **Rapports** : Graphiques simples sur la répartition des types de parcelles (Résidentiel vs Commercial, etc.).
6.  **Paramètres** : Gestion du profil et configuration de la sécurité (2FA).

---

## 3. Workflow de Création de Fiche (Multi-Step Form)

Le processus de création doit suivre précisément les 6 étapes de la version Web :
  ca doit venir deja de notre base de donnee tout doit etre dynamique meme la connexion auth. l'application mobile ne fait qu'utiliser les donnees de la base de donnee
### Étape 1 : Localisation Administrative
- **Ville** : Fixée à "Kinshasa".
- **Commune** : Présélectionnée selon le profil du Chef de Quartier.
- **Quartier** : Liste déroulante filtrée par la commune.
- **Code Postal** : Auto-généré selon le quartier sélectionné.
- **Localisation GPS** : Capture précise via le GPS du mobile (Lat/Long) avec affichage sur carte pour ajustement manuel.
- **Adresse Physique** : Saisie textuelle (N°, Avenue, Références).

### Étape 2 : Détails de la Parcelle
- **Année** : Par défaut l'année en cours.
- **Type de Parcelle** : Choix unique (Résidentiel, Commercial, Confessionnel, Mixte).
- **Si Mixte** : Sélection multiple des catégories incluses.
- **Superficie** : Saisie de la valeur en m² (calculateur optionnel Longueur x Largeur).
- **Références** : Numéro de contrat ou réf. du rapport d'inspection.

### Étape 3 : Informations du Propriétaire
- **Type de détenteur** : Personne Physique ou Morale (ASBL, Société).
- **Identité** : Nom, Post-nom, Prénom (ou Raison Sociale).
- **Adresse du Propriétaire** : Domicile actuel.
- **Détails** : État civil, Lieu et Date de naissance, Nationalité.
- **Identifiant** : Type de pièce d'identité et numéro.

### Étape 4 : Occupants (Unités & Résidents)
*C'est l'étape la plus complexe, nécessitant une ergonomie mobile fluide.*
- **Génération d'unités** : Saisie du nombre d'appartements/locaux à créer.
- **Gestion des Unités** : Liste des unités créées. Chaque unité peut être renommée (ex: "Appartement A", "Boutique 1").
- **Recensement des habitants (par unité)** :
    - Formulaire de résident : Identité complète, Sexe, État civil.
    - Profession, Nationalité, Quartier d'origine.
    - Ancienne adresse et Date d'arrivée.
    - Observations et Photo du résident.

### Étape 5 : Galerie & Documents (Uploads)
- **Photo de la Parcelle** : Capture directe via la caméra.
- **Photo du Propriétaire** : Photo passeport ou portrait.
- **Photo des Documents** : Carte d'identité, actes de vente, etc.

### Étape 6 : Récapitulatif & Validation
- Affichage de toutes les données saisies pour une dernière vérification avant transmission au serveur.

---

## 4. Spécifications Techniques Mobiles
- **Plateforme** : Flutter (Android priorité 1).
- **Communication** : API REST avec le backend Next.js.
- **Sécurité** : 
    - Connexion avec validation du token 2FA (TOTP).
    - Stockage sécurisé des identifiants (Secure Storage).
- **Mode Offline** : Mise en attente locale des fiches si le réseau est instable, avec synchronisation manuelle/automatique une fois en ligne.
- **Services** : 
    - Geolocation (GPS haute précision).
    - Camera (Compression d'image avant upload pour économiser la data).

---

## 5. Design & Identité Visuelle
- **Style** : "Kinshasa Modern"
- **Colorimétrie** :
    - Bleu Institutionnel : `#050066`
    - Or/Accent : `#d9871b`
    - Neutres : Slate (Gris ardoise) pour le texte et les bordures.
- **Composants** : Utilisation de cartes (Cards) et de listes ombrées pour un aspect premium.
