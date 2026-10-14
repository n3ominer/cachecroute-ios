import SwiftUI

/// Racine de l'interface : aiguille vers l'écran de départ décidé par `RootModel`.
///
/// PÉDAGO — navigation pilotée par l'état :
///  - Le `switch` choisit la branche affichée. Se connecter (→ `currentUser` non-nil) ou se
///    déconnecter (→ nil) recalcule `startDestination` et SwiftUI remplace toute la branche. Pas
///    de pile de retour à gérer entre les grands flux : c'est le `popUpTo` d'Android, en gratuit.
struct AppRootView: View {
    let dependencies: AppDependencies
    @State private var root: RootModel

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _root = State(initialValue: RootModel(
            onboardingStore: dependencies.onboardingStore,
            authService: dependencies.authService
        ))
    }

    var body: some View {
        switch root.startDestination {
        case .loading:
            SplashView()
        case .onboarding:
            OnboardingView(onFinished: { root.markOnboardingSeen() })
        case .auth:
            AuthFlowView(authService: dependencies.authService)
        case .home:
            HomeView(authService: dependencies.authService)
        }
    }
}

/// Flux d'authentification : Connexion ⇄ Inscription dans une `NavigationStack`.
///
/// PÉDAGO : la navigation INTERNE au flux (vers l'inscription) utilise `navigationDestination`.
/// La sortie du flux (succès) n'est PAS gérée ici : elle découle de l'état (session non-nil) qui
/// fait rebasculer `AppRootView` vers `.home`.
struct AuthFlowView: View {
    let authService: AuthService
    @State private var showSignup = false

    var body: some View {
        NavigationStack {
            LoginView(authService: authService, onNavigateToSignup: { showSignup = true })
                .navigationDestination(isPresented: $showSignup) {
                    SignupView(authService: authService)
                }
        }
    }
}
