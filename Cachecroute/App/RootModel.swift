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
    
    // TODO: Ajouter un constante pour stocker la ref vers le service (repository) d'auth
    // TODO: Gerer un temps de  4 secondes de splashscreen + mise à jour de l'état une fois le temps passé

    init(onboardingStore: OnboardingStore /* TODO: Ajout de l'AuthService */) {
        self.onboardingStore = onboardingStore
        // TODO: Instancier le service
        
        // TODO: Ajouter une Task, pour emuler 4 sec de traitement pour laisser le splash screen apparaitre
    }

    var startDestination: StartDestination {
        // TODO: Ajouter dans le guard la prise en compte du temps d'attente
        guard onboardingStore.isReady else { return .loading }
        // TODO: Gérer les différent cas de routing vers .onboarding et .auth
        return onboardingStore.hasSeenOnboarding ? .home : .onboarding
        // TODO: Si aucune des routes precedente n'est routable, rediriger vers .home
    }

    /// Appelé quand l'utilisateur termine (ou passe) l'onboarding.
    func markOnboardingSeen() {
        onboardingStore.markSeen()
    }
}
