import Foundation
import Observation

/// Décide de l'écran de départ. **Seul endroit** qui porte cette décision.
///
/// PÉDAGO :
///  - `@Observable` : `startDestination` est une propriété CALCULÉE qui lit l'état du store. Comme
///    le store est lui-même `@Observable`, toute vue qui lit `startDestination` se recompose quand
///    `hasSeenOnboarding` change. C'est l'équivalent iOS du `combine(...).stateIn(...)` d'Android :
///    on fusionne des sources d'état réactives, ici une seule (l'onboarding). On en ajoutera.
///
/// Tableau de vérité (version séance 1·A) :
///   pas prêt                 → .loading (écran de lancement)
///   onboarding non vu        → .onboarding
///   onboarding vu            → .home
@Observable
@MainActor
final class RootModel {
    @ObservationIgnored private let onboardingStore: OnboardingStore

    init(onboardingStore: OnboardingStore) {
        self.onboardingStore = onboardingStore
    }

    var startDestination: StartDestination {
        guard onboardingStore.isReady else { return .loading }
        return onboardingStore.hasSeenOnboarding ? .home : .onboarding
    }

    /// Appelé quand l'utilisateur termine (ou passe) l'onboarding.
    func markOnboardingSeen() {
        onboardingStore.markSeen()
    }
}
