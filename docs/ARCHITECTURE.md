# Architecture (iOS · SwiftUI)

Projet **cible unique** (`Cachecroute`), **MVVM léger**, découpage **par feature**. Objectif :
tout s'explique au tableau en 5 minutes. Pas de sur-ingénierie, pas de framework de DI externe.

## Couches

```
┌──────────────────────────────────────────────────────────────┐
│ presentation   Vues SwiftUI + ViewModel (@Observable) + State  │
│                (Observation, @State, bindings)                 │
├──────────────────────────────────────────────────────────────┤
│ domain         Modèles + PROTOCOLES (store/service/repository) │
│                (Swift pur, testable, sans UIKit)              │
├──────────────────────────────────────────────────────────────┤
│ data           Implémentations : UserDefaults / InMemory /     │
│                Fake / Firebase (optionnel)                    │
└──────────────────────────────────────────────────────────────┘
        ▲ AppDependencies (composition root) câble les protocoles
```

**Inversion de dépendance** : le reste de l'app ne dépend que des **protocoles** (`OnboardingStore`,
`AuthService`, `HouseRepository`). On peut donc injecter un **faux** dans les tests sans toucher aux
vues ni aux ViewModels.

## Équivalences Android → iOS (les bonnes pratiques, pas une traduction)

| Android / Kotlin | iOS / Swift |
|---|---|
| Hilt (`@HiltAndroidApp`, modules `@Provides/@Binds`) | `AppDependencies` (composition root explicite) injecté par la vue racine |
| `@HiltViewModel` + `ViewModel` | classe `@Observable @MainActor` (framework Observation) |
| `StateFlow` / `collectAsStateWithLifecycle` | propriétés `@Observable` lues directement dans les vues |
| `combine(...).stateIn(...)` | propriété **calculée** qui lit plusieurs services observables |
| `Flow<Boolean>` (DataStore) | `UserDefaults` + propriété `@Observable` |
| `sealed interface` (`StartDestination`, `AuthResult`) | `enum` (`StartDestination`) / `async throws` |
| Navigation Compose + routes typées | `NavigationStack` + `enum` de route `Hashable` (arguments typés) |
| `HorizontalPager` | `TabView` + `.tabViewStyle(.page)` |
| `installSplashScreen` + `setKeepOnScreenCondition` | état `.loading` → `SplashView` (navigation pilotée par l'état) |
| `Channel` (événement one-shot) | closure `onAuthenticated` (événement) ; sinon état |
| `popUpTo` (vider la pile) | swap de la vue racine (l'ancien flux disparaît, gratuit) |
| `Random` injecté | `RandomNumberGenerator` injecté (générateur à graine en test) |
| VectorDrawable + `@DrawableRes` | Asset Catalog (SVG) + **SF Symbols** pour les icônes génériques |

## Décision de départ

`RootModel.startDestination` est le **seul** endroit qui décide de l'écran initial, à partir de
trois sources observables : onboarding vu ? session ? maison ? La navigation entre grands flux
découle de l'**état** (idiome SwiftUI) : se connecter, créer/rejoindre une maison ou se déconnecter
recalcule la destination et SwiftUI remplace la branche affichée.

## Arborescence

```
Cachecroute/
  App/            CachecrouteApp, AppRootView, RootModel, StartDestination, SplashView, AppDependencies
  DesignSystem/   Theme (couleurs), Tokens, Typography, Components/ (kit Fournil)
  Core/           Validators (Swift pur)
  Features/
    Home/         HomeView, HomeModel
    Onboarding/   OnboardingStore (+UserDefaults), OnboardingView
    Auth/         AuthModels, AuthService (+Fake/+Firebase), AuthViewModel, Login/Signup/Header
    House/        House, HouseRepository (+InMemory), HouseCodeGenerator, Create/Join models + écrans
  Resources/      Assets.xcassets (couleurs d'accent, illustrations SVG), Fonts/ (Young Serif, Hanken)
CachecrouteTests/ Swift Testing (Onboarding, Auth, House, RootModel)
```
