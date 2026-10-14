import Foundation

/// Contrat d'authentification. Deux implémentations : `FakeAuthService` (hors réseau, défaut + tests)
/// et `FirebaseAuthService` (réel, optionnel). Le reste de l'app ne dépend que de ce protocole.
///
/// PÉDAGO : `currentUser` est l'état de session OBSERVABLE (les implémentations sont `@Observable`).
/// `RootModel` le lit pour décider entre `.auth` et `.home`. Les opérations sont `async throws` :
/// elles réussissent (renvoient l'utilisateur) ou lèvent une `AuthError` — idiome Swift, plus
/// direct que le `sealed AuthResult` d'Android.
@MainActor
protocol AuthService: AnyObject {
    var currentUser: AuthUser? { get }

    func signUp(pseudo: String, email: String, password: String) async throws -> AuthUser
    func signIn(email: String, password: String) async throws -> AuthUser
    func signOut()
}
