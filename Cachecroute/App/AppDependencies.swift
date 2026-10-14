import Foundation

/// Racine de composition (« composition root ») : le SEUL endroit qui fabrique et câble les
/// services de l'app.
///
/// PÉDAGO : équivalent iOS des modules Hilt, mais explicite. Le choix d'implémentation se fait ICI,
/// à un seul endroit. Par défaut on branche `FakeAuthService` (aucun réseau). Pour utiliser le vrai
/// Firebase, on remplacerait par `FirebaseAuthService()` (voir ce fichier) — les écrans, eux, ne
/// dépendent que du protocole `AuthService` : ils ignorent quel moteur est derrière.
@MainActor
final class AppDependencies {
    let onboardingStore: OnboardingStore
    let authService: AuthService

    init(onboardingStore: OnboardingStore? = nil, authService: AuthService? = nil) {
        self.onboardingStore = onboardingStore ?? UserDefaultsOnboardingStore()
        self.authService = authService ?? FakeAuthService()
    }
}
