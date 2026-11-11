import Foundation
import Observation

/// Implémentation du drapeau « onboarding vu » via `UserDefaults`.
///
/// PÉDAGO :
///  - `@Observable` (framework Observation, iOS 17+) : dès que `hasSeenOnboarding` change, toute vue
///    qui l'a lu se recompose. C'est l'équivalent iOS du `Flow`/`StateFlow` d'Android — sans boilerplate.
///  - On REÇOIT le `UserDefaults` par l'initialiseur (défaut `.standard`). Pourquoi ? Pour pouvoir
///    injecter un `UserDefaults(suiteName:)` jetable dans les tests. Réflexe : on reçoit, on ne crée pas.
@Observable
@MainActor
final class UserDefaultsOnboardingStore: OnboardingStore {
    @ObservationIgnored private let defaults: UserDefaults
    private static let key = "onboarding_seen"

    private(set) var isReady = false
    private(set) var hasSeenOnboarding = false

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        // UserDefaults est synchrone : on lit tout de suite, puis on se déclare prêt.
        hasSeenOnboarding = defaults.bool(forKey: Self.key)
        isReady = true
    }

    func markSeen() {
        defaults.set(true, forKey: Self.key)
        hasSeenOnboarding = true
    }
}
