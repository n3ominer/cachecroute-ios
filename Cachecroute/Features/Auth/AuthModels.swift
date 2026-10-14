import Foundation

/// Utilisateur authentifié (vue métier, indépendante de Firebase).
struct AuthUser: Equatable, Identifiable {
    let id: String      // uid
    let pseudo: String?
    let email: String?
}

/// Erreurs d'authentification « métier » (indépendantes de Firebase).
///
/// PÉDAGO : on ne laisse JAMAIS remonter un code technique à l'écran. On le traduit d'abord en une
/// de ces valeurs. En Swift, idiome : l'erreur conforme à `Error`, on la `throw`, et la vue choisit
/// le message. On n'utilise pas le `sealed AuthResult` d'Android : `async throws` est plus swifty.
enum AuthError: Error, Equatable {
    case invalidEmail
    case invalidCredentials
    case emailAlreadyInUse
    case weakPassword
    case network
    case tooManyAttempts
    case unknown

    /// Message FR affiché (dans la carte d'erreur globale). La vue reste maître de l'affichage ;
    /// le service, lui, ne connaît que le cas métier.
    var message: String {
        switch self {
        case .invalidEmail: "Cet email ne semble pas valide."
        case .invalidCredentials: "Email ou mot de passe incorrect."
        case .emailAlreadyInUse: "Un compte existe déjà avec cet email."
        case .weakPassword: "Mot de passe trop faible (8 caractères minimum)."
        case .network: "Pas de connexion. Réessayez."
        case .tooManyAttempts: "Trop de tentatives. Réessayez plus tard."
        case .unknown: "Une erreur est survenue. Réessayez."
        }
    }
}

/// Traduit un code d'erreur Firebase (`AuthErrorCode`) en `AuthError` métier.
///
/// PÉDAGO : fonction **pure** (entrée = `String?`, sortie = `AuthError`), donc testable sans
/// Firebase. C'est la cible de `AuthErrorMapperTests`. Utilisée par `FirebaseAuthService`.
func mapFirebaseAuthError(_ code: String?) -> AuthError {
    switch code {
    case "ERROR_INVALID_EMAIL": .invalidEmail
    case "ERROR_INVALID_CREDENTIAL", "ERROR_WRONG_PASSWORD", "ERROR_USER_NOT_FOUND", "ERROR_USER_DISABLED":
        .invalidCredentials
    case "ERROR_EMAIL_ALREADY_IN_USE": .emailAlreadyInUse
    case "ERROR_WEAK_PASSWORD": .weakPassword
    case "ERROR_NETWORK_REQUEST_FAILED": .network
    case "ERROR_TOO_MANY_REQUESTS": .tooManyAttempts
    default: .unknown
    }
}
