import Foundation
import Observation

/// Décide de l'écran de départ. **Seul endroit** qui porte cette décision.
///
/// PÉDAGO :
///  - `startDestination` est CALCULÉE à partir de plusieurs sources observables (onboarding +
///    session). C'est l'équivalent iOS du `combine(onboarding, session)` d'Android : quand l'une
///    d'elles change (connexion, déconnexion), la propriété se recalcule et l'UI se recompose.
///  - On ajoutera la maison en séance 2 (troisième source).
///
/// Tableau de vérité (version séance 1) :
///   pas prêt ou splash encore affiché      → .loading
///   onboarding non vu                     → .onboarding
///   vu + non connecté                     → .auth
///   vu + connecté                         → .home
@Observable
@MainActor
final class RootModel {
    private static let minimumSplashDurationNanoseconds: UInt64 = 4_000_000_000

    @ObservationIgnored private let onboardingStore: OnboardingStore
    @ObservationIgnored private let authService: AuthService

    private(set) var hasFinishedSplashDelay = false

    init(onboardingStore: OnboardingStore, authService: AuthService) {
        self.onboardingStore = onboardingStore
        self.authService = authService

        // UserDefaults est lu de façon synchrone : garde le splash visible au moins une seconde.
        // Task.sleep suspend cette tâche sans bloquer le thread principal.
        Task {
            try? await Task.sleep(nanoseconds: RootModel.minimumSplashDurationNanoseconds)
            hasFinishedSplashDelay = true
        }
    }

    var startDestination: StartDestination {
        guard onboardingStore.isReady, hasFinishedSplashDelay else { return .loading }
        if !onboardingStore.hasSeenOnboarding { return .onboarding }
        if authService.currentUser == nil { return .auth }
        return .home
    }

    func markOnboardingSeen() {
        onboardingStore.markSeen()
    }
}
