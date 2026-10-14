import Foundation
import Observation

/// ViewModel partagé par les écrans Connexion et Inscription.
///
/// PÉDAGO :
///  - `@Observable` : un SEUL état produit les 5 rendus des maquettes (vide, rempli, erreur de
///    champ, erreur globale, chargement). On ne fait pas 5 écrans.
///  - Les messages d'erreur sont des `String?` portés par le ViewModel ; `nil` = pas d'erreur.
///  - `onAuthenticated` est l'ÉVÉNEMENT ponctuel « connecté » : une closure appelée une fois au
///    succès. C'est l'équivalent iOS du `Channel` d'Android (à ne pas confondre avec l'état durable).
///    La navigation, elle, est pilotée par l'état : quand `authService.currentUser` passe non-nil,
///    `RootModel` rebascule vers `.home` tout seul.
@Observable
@MainActor
final class AuthViewModel {
    var pseudo = ""
    var email = ""
    var password = ""
    var confirmPassword = ""

    var pseudoError: String?
    var emailError: String?
    var passwordError: String?
    var confirmError: String?
    var globalError: String?
    var isLoading = false

    @ObservationIgnored private let authService: AuthService
    @ObservationIgnored var onAuthenticated: (() -> Void)?

    init(authService: AuthService) {
        self.authService = authService
    }

    func submitLogin() async {
        emailError = Validators.isValidEmail(email) ? nil : "Cet email ne semble pas valide."
        passwordError = Validators.isValidPassword(password) ? nil : "8 caractères minimum."
        guard emailError == nil, passwordError == nil else { globalError = nil; return }
        await run { try await self.authService.signIn(email: self.email, password: self.password) }
    }

    func submitSignup() async {
        pseudoError = Validators.isValidPseudo(pseudo) ? nil : "Choisissez un pseudo."
        emailError = Validators.isValidEmail(email) ? nil : "Cet email ne semble pas valide."
        passwordError = Validators.isValidPassword(password) ? nil : "8 caractères minimum."
        confirmError = Validators.passwordsMatch(password, confirmPassword) ? nil : "Les mots de passe diffèrent."
        guard pseudoError == nil, emailError == nil, passwordError == nil, confirmError == nil else {
            globalError = nil; return
        }
        await run { try await self.authService.signUp(pseudo: self.pseudo, email: self.email, password: self.password) }
    }

    /// Efface l'erreur d'un champ dès que l'utilisateur corrige (appelé depuis la vue).
    func clearErrors() {
        emailError = nil; passwordError = nil; pseudoError = nil; confirmError = nil; globalError = nil
    }

    private func run(_ operation: () async throws -> AuthUser) async {
        isLoading = true
        globalError = nil; emailError = nil; passwordError = nil; confirmError = nil
        do {
            _ = try await operation()
            isLoading = false
            onAuthenticated?()
        } catch let error as AuthError {
            isLoading = false
            globalError = error.message
        } catch {
            isLoading = false
            globalError = AuthError.unknown.message
        }
    }
}
