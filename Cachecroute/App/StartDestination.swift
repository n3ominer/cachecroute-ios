import Foundation

/// Écran de départ calculé au lancement (voir `RootModel`).
///
/// PÉDAGO : un `enum` Swift = un ensemble FERMÉ de cas, comme le `sealed interface` d'Android. Le
/// `switch` dessus est exhaustif (le compilateur vérifie qu'on n'oublie aucun cas). Les séances
/// suivantes ajouteront `.auth` (connexion) et `.house` (choix de maison).
enum StartDestination: Equatable {
    /// On lit encore l'état : on garde l'écran de lancement.
    case loading
    /// Onboarding pas encore vu.
    case onboarding
    /// Accueil.
    case home
}
