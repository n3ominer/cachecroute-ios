import SwiftUI

/// Racine de l'interface : aiguille vers l'écran de départ décidé par `RootModel`.
///
/// PÉDAGO — la navigation pilotée par l'état (idiome SwiftUI).
///  - Un `switch` sur `root.startDestination` choisit la racine affichée. Quand l'état change
///    (onboarding marqué vu → `.home`), SwiftUI remplace TOUT l'arbre : il n'y a aucune pile de
///    retour vers l'onboarding. C'est l'équivalent naturel du `popUpTo` d'Android, gratuit.
///  - `.loading` montre l'écran de lancement de marque : le pendant iOS du « splash retenu »
///    d'Android, mais ici piloté par notre état plutôt que par une API système.
struct AppRootView: View {
    let dependencies: AppDependencies
    @State private var root: RootModel

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _root = State(initialValue: RootModel(onboardingStore: dependencies.onboardingStore))
    }

    var body: some View {
        switch root.startDestination {
        case .loading:
            SplashView()
        case .onboarding:
            OnboardingView(onFinished: { root.markOnboardingSeen() })
        case .home:
            HomeView()
        }
    }
}
