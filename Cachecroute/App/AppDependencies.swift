import Foundation

/// Racine de composition (« composition root ») : le SEUL endroit qui fabrique et câble les
/// services de l'app.
///
/// PÉDAGO : c'est l'équivalent iOS des modules Hilt d'Android, mais explicite et sans magie. Chaque
/// feature ajoutera ici son service (auth, maison) et la « cascade » de dépendances qu'il entraîne.
/// On injecte ensuite ce conteneur vers le bas de l'arbre de vues ; les vues en extraient ce dont
/// elles ont besoin pour construire leurs modèles. Avantage : testable (on peut fabriquer un
/// conteneur avec des faux) et lisible (tout le câblage est à un seul endroit).
@MainActor
final class AppDependencies {
    let onboardingStore: OnboardingStore

    init(onboardingStore: OnboardingStore? = nil) {
        self.onboardingStore = onboardingStore ?? UserDefaultsOnboardingStore()
    }
}
