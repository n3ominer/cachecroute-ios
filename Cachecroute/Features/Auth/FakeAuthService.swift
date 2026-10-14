import Foundation
import Observation

/// Implémentation EN MÉMOIRE de l'authentification. C'est l'implémentation **par défaut** de l'app
/// (aucun réseau requis) et la base des tests. Compte de démonstration pré-créé :
/// `demo@cachecrout.app` / `motdepasse1`.
///
/// PÉDAGO : le `FakeAuthService` n'est pas « du code jetable ». Il implémente le MÊME protocole que
/// la version Firebase. Il tourne out-of-the-box en cours, et sert dans les tests du ViewModel.
@Observable
@MainActor
final class FakeAuthService: AuthService {
    private struct Account { let user: AuthUser; let password: String }

    @ObservationIgnored private var accounts: [String: Account] = [:]
    private(set) var currentUser: AuthUser?

    init() {
        let demo = AuthUser(id: "demo-uid", pseudo: "Démo", email: Self.demoEmail)
        accounts[Self.demoEmail] = Account(user: demo, password: Self.demoPassword)
    }

    func signUp(pseudo: String, email: String, password: String) async throws -> AuthUser {
        let key = email.trimmingCharacters(in: .whitespaces).lowercased()
        if accounts[key] != nil { throw AuthError.emailAlreadyInUse }
        guard Validators.isValidPassword(password) else { throw AuthError.weakPassword }
        let user = AuthUser(id: key, pseudo: pseudo.trimmingCharacters(in: .whitespaces), email: key)
        accounts[key] = Account(user: user, password: password)
        currentUser = user
        return user
    }

    func signIn(email: String, password: String) async throws -> AuthUser {
        let key = email.trimmingCharacters(in: .whitespaces).lowercased()
        guard let account = accounts[key], account.password == password else {
            throw AuthError.invalidCredentials
        }
        currentUser = account.user
        return account.user
    }

    func signOut() { currentUser = nil }

    private static let demoEmail = "demo@cachecrout.app"
    private static let demoPassword = "motdepasse1"
}
