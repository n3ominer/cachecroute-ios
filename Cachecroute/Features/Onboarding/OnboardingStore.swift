import Foundation

/// Mémorise si l'utilisateur a déjà vu l'onboarding.
///
/// PÉDAGO : on définit un PROTOCOLE (le contrat), pas une implémentation. Le reste de l'app ne
/// dépend que de lui — on peut donc le remplacer par un faux en mémoire dans les tests. C'est
/// l'équivalent iOS de l'interface `OnboardingRepository` d'Android : séparer le « quoi » (contrat)
/// du « comment » (UserDefaults).
///
/// `isReady` modélise un éventuel chargement asynchrone (ici quasi instantané car UserDefaults est
/// synchrone) : il permet de garder un écran de lancement tant que l'état n'est pas connu.
@MainActor
protocol OnboardingStore: AnyObject {
    var isReady: Bool { get }
    var hasSeenOnboarding: Bool { get }
    func markSeen()
}
