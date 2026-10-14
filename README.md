# CacheCroûte — iOS (SwiftUI)

Application pédagogique du cours de dev mobile, version **iOS / SwiftUI** (pendant de la version
Android/Compose). Gestion du stock et des courses d'une coloc : onboarding, authentification,
section « maison ».

## Démarrer

1. Ouvrir `Cachecroute.xcodeproj` dans **Xcode 16+**.
2. Choisir un simulateur iPhone, `Cmd+R`. (Aucune dépendance externe : auth en mode Fake par défaut.)
3. Tests : `Cmd+U` (framework **Swift Testing**).

Compte de démo (mode Fake) : `demo@cachecrout.app` / `motdepasse1`.

## Organisation

- **Socle** sur `main`, features sur `feature/*` (starters à compléter) et `solution/*` (corrigés).
- Voir [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md), [`docs/PROFESSEUR.md`](docs/PROFESSEUR.md).
- Design system « Fournil » : couleurs dynamiques clair/sombre, polices Young Serif + Hanken Grotesk,
  icônes via SF Symbols, illustrations en Asset Catalog.

Firebase est **optionnel** (documenté dans `FirebaseAuthService.swift` et `docs/PROFESSEUR.md`).
