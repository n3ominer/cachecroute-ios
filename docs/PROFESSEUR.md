# Guide du professeur (iOS · SwiftUI)

Support de **deux séances de 3 h**. Live coding + exercices + correction. Périmètre :
Splash/Onboarding, Authentification (service Fake par défaut, Firebase optionnel), section Maison.

---

## 0. À vérifier AVANT la séance

- **Xcode 16+** (testé Xcode 26, Swift 5/6, SDK iOS 18/26). `IPHONEOS_DEPLOYMENT_TARGET = 17.0`.
- Un **simulateur** iPhone disponible (ex. iPhone 17), ou un appareil.
- `xcodebuild ... build` et `... test` passent au vert sur `main` et `solution/*`.
- Aucune dépendance externe requise : l'app tourne avec `FakeAuthService` (compte démo
  `demo@cachecrout.app` / `motdepasse1`). **Firebase est optionnel** (voir § Firebase).

> Le projet utilise des **groupes synchronisés** (Xcode 16+) : ajouter un fichier dans un dossier
> du groupe l'inclut automatiquement à la cible, sans toucher au `.xcodeproj`.

---

## 1. Carte des branches

| Branche | Rôle | Poussée sur origin ? |
|---|---|---|
| `main` | Socle distribué au début de la séance 1 | **oui** |
| `feature/splash-onboarding` | Starter séance 1·A | oui |
| `solution/splash-onboarding` | Correction A | non (dépôt public) |
| `feature/auth` | Starter séance 1·B+C | oui |
| `solution/auth` | Correction fin séance 1 | non |
| `feature/maison` | Starter séance 2 | oui |
| `solution/maison` | Correction fin séance 2 | non |

Chaînage : `feature/auth` part de la solution onboarding, `feature/maison` de la solution auth.
Un étudiant en retard repart d'une base correcte en changeant de branche.

> **Politique de push** (dépôt public) : ne JAMAIS pousser `solution/*` (les étudiants verraient la
> correction). Pousser uniquement `main` + `feature/*`. Jamais `--force`.

---

## 2. Déroulé

### Séance 1 — Splash, Onboarding, Auth
- **A** (`feature/splash-onboarding`) : `UserDefaultsOnboardingStore` (TODO S1-01), `RootModel`
  (TODO S1-02), onboarding (`TabView` .page), navigation pilotée par l'état.
  → `OnboardingStoreTests`, `RootModelTests` au vert.
- **B+C** (`feature/auth`) : `Validators` (S1-05), `mapFirebaseAuthError` (S1-09), `AuthViewModel`
  (S1-10). Service Fake fourni ; écrans fournis.
  → `ValidatorsTests`, `AuthErrorMapperTests`, `AuthViewModelTests` au vert.

### Séance 2 — Maison
- `feature/maison` : `HouseCodeGenerator` (S2-01), `InMemoryHouseRepository` (S2-01/04),
  `JoinHouseModel` (S2-05). Écrans + routes typées fournis.
  → `HouseCodeGeneratorTests`, `HouseRepositoryTests`, `JoinHouseModelTests`, `RootModelTests` vert.

---

## 3. Lancer / tester

```bash
# Build + tests (remplacer le nom du simulateur si besoin)
xcodebuild -project Cachecroute.xcodeproj -scheme Cachecroute \
  -destination 'platform=iOS Simulator,name=iPhone 17' test
```

Attendu : `main` + `solution/*` **tout vert** ; `feature/*` **compilent** mais leurs tests
« À compléter » sont **rouges** (c'est le travail du cours).

---

## 4. Firebase (optionnel)

Par défaut, `AppDependencies` injecte `FakeAuthService` (aucun réseau). Pour brancher le vrai
Firebase :
1. Xcode ▸ *File ▸ Add Package Dependencies…* → `https://github.com/firebase/firebase-ios-sdk`,
   produit **FirebaseAuth**.
2. Déposer `GoogleService-Info.plist` (ignoré par git) dans la cible.
3. `FirebaseAuthService` (déjà écrit, derrière `#if canImport(FirebaseAuth)`) devient compilable ;
   l'injecter à la place du fake dans `AppDependencies`.

---

## 5. Fin de séance — correction

On ne fusionne PAS les solutions dans `main` avant la fin de la séance, devant les étudiants :

```bash
git checkout main
git merge --no-ff solution/splash-onboarding   # fin séance 1·A
git merge --no-ff solution/auth                 # fin séance 1
git merge --no-ff solution/maison               # fin séance 2
git push origin main
```
