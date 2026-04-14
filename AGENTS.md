# AGENTS.md

## But du projet

Construire une application Flutter Android prioritaire, 100 % locale et hors ligne, inspirée du concept de EVA Battle Plan, sans backend distant.

L'application doit permettre :
- de créer et éditer des battleplans sur cartes avec éléments positionnés
- de consulter un wiki local d'armes avec recherche et filtres
- de gérer les paramètres locaux, dont export/import JSON, reset des données et thème sombre

Toutes les données doivent fonctionner sans connexion réseau et rester persistées localement.

## Stack technique

- Flutter
- Riverpod
- GoRouter
- Drift avec SQLite
- Freezed
- json_serializable

Packages utilitaires autorisés si nécessaires :
- `path_provider`
- `sqlite3_flutter_libs`
- `file_picker`
- `share_plus`
- `collection`

## Conventions de nommage

- Utiliser `snake_case` pour les fichiers et dossiers
- Utiliser `PascalCase` pour les classes, widgets, enums et typedefs
- Utiliser `camelCase` pour les variables, paramètres, fonctions et méthodes
- Utiliser des noms explicites, orientés métier
- Éviter les abréviations non évidentes
- Suffixes attendus quand pertinents :
  - `*_screen.dart` pour les écrans
  - `*_controller.dart` pour la logique d'état
  - `*_repository.dart` pour les contrats et implémentations de repository
  - `*_provider.dart` pour les providers Riverpod
  - `*_table.dart` pour les tables Drift
  - `*_dto.dart` pour les objets de transfert
  - `*_mapper.dart` pour les mappings
  - `*_service.dart` pour les services techniques
  - `*_usecase.dart` pour les cas d'usage

## Organisation des dossiers

Le projet doit rester organisé par responsabilité et par feature.

Structure cible :
- `lib/app` : bootstrap, router, shell de navigation, thème
- `lib/core` : constantes, erreurs, utilitaires, widgets partagés
- `lib/data` : base locale, tables Drift, services de stockage, seed local
- `lib/domain` : entités métier, contrats de repository, cas d'usage
- `lib/features` : implémentation par feature (`battleplans`, `wiki`, `settings`)
- `lib/shared` : providers transverses et modèles communs
- `assets/data` : JSON locaux versionnés
- `assets/images` : images de cartes, armes et icônes
- `test` : tests unitaires, widgets et intégration légère

Chaque feature doit rester découpée en sous-dossiers spécialisés :
- `data`
- `logic`
- `presentation`

## Règles d'architecture

- Utiliser une architecture modulaire, propre et maintenable
- Séparer clairement `presentation`, `application/logic`, `domain` et `data`
- Les widgets ne doivent contenir que de la composition UI et des interactions simples
- Toute logique métier doit vivre dans des contrôleurs, cas d'usage, services ou repositories
- Drift est la source de vérité locale pour les données persistées
- Les formats d'import/export JSON doivent être explicitement modélisés
- Les entités métier doivent être immuables quand c'est pertinent
- Préférer des composants petits et spécialisés plutôt que des fichiers polyvalents
- Chaque fichier doit avoir une responsabilité claire
- Éviter les dépendances circulaires entre features
- Préférer l'injection via Riverpod plutôt que l'instanciation directe dans l'UI

## Règles de qualité

- Toujours garder l'application compilable à chaque étape
- Toute modification doit laisser un état cohérent et exécutable
- Ne pas introduire de dette technique évitable pour aller plus vite
- Favoriser des fichiers petits et spécialisés
- Éviter les gros fichiers monolithiques
- Écrire du code lisible avant d'écrire du code abstrait
- Commenter seulement quand le code n'est pas auto-explicatif
- Éviter les commentaires redondants
- Ajouter des tests sur la logique métier et les mappings dès qu'une zone devient non triviale
- Vérifier les cas d'erreur, états vides et cas limites
- Garder des APIs internes simples et cohérentes
- Supprimer les structures mortes ou temporaires dès qu'elles ne servent plus

## Règles UI

- L'application cible d'abord Android
- L'UX doit être fluide, lisible et moderne
- Le thème sombre est requis et doit être traité comme un besoin produit, pas comme un ajout cosmétique
- Respecter une hiérarchie visuelle nette
- Concevoir pour mobile avant tout
- Prévoir les états suivants sur chaque écran si pertinents :
  - chargement
  - vide
  - erreur
  - contenu
- Les interactions de carte doivent rester fluides :
  - zoom
  - pan
  - placement
  - déplacement d'éléments
- Les composants UI doivent être réutilisables quand ils représentent un pattern partagé
- Ne pas mélanger logique de persistance et rendu UI dans un même widget

## Règles de persistance locale

- Aucune donnée métier ne doit dépendre d'un backend
- Aucune fonctionnalité principale ne doit nécessiter Internet
- Les données utilisateur doivent être persistées localement via Drift/SQLite
- Les données catalogue locales peuvent être seedées depuis des assets JSON embarqués
- Les images de cartes et d'armes doivent être stockées localement comme assets ou fichiers locaux contrôlés par l'application
- L'import/export doit utiliser un format JSON applicatif lisible et versionné
- Les préférences utilisateur doivent être stockées localement
- Toute écriture locale doit être déterministe et validée
- Les suppressions destructives doivent être confirmées côté UI

## Règles de migration de base de données

- Toute évolution de schéma Drift doit être accompagnée d'une stratégie de migration explicite
- Ne jamais casser silencieusement les données locales existantes
- Versionner le schéma de base de données
- Prévoir les migrations montantes dès l'ajout ou la modification d'une table
- Prévoir si nécessaire une stratégie de reseed contrôlée pour les données catalogue
- Ne pas mélanger migration de schéma et refactor massif non lié dans la même étape si cela nuit à la lisibilité
- Tester les migrations sur des cas réalistes dès qu'une version de schéma évolue
- Le reset complet doit rester une action volontaire distincte des migrations

## Interdictions

- Pas de backend
- Pas de Firebase
- Pas de logique métier dans les widgets
- Pas de gros fichiers monolithiques
- Pas de dépendance réseau pour les fonctionnalités cœur
- Pas de stockage ad hoc non centralisé pour contourner l'architecture
- Pas de couplage fort entre UI et accès aux données

## Règles d'exécution pour l'agent

- Toujours proposer des fichiers petits et spécialisés
- Toujours garder l'app compilable à chaque étape
- Avant d'implémenter, vérifier où placer le code dans l'architecture cible
- Préférer étendre l'existant proprement plutôt que créer des couches inutiles
- En cas d'hésitation, choisir la solution la plus simple compatible avec la maintenabilité long terme
- Si une décision structurelle impacte plusieurs features, aligner d'abord le socle partagé
