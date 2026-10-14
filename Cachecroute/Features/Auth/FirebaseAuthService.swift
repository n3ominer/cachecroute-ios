import Foundation

// MARK: - Implémentation Firebase (OPTIONNELLE)
//
// PÉDAGO : l'app tourne par défaut avec `FakeAuthService` (aucune dépendance). Pour brancher le
// VRAI Firebase, les étudiants ajoutent le paquet Swift `firebase-ios-sdk` (produit `FirebaseAuth`)
// dans Xcode (File ▸ Add Package Dependencies…) et déposent leur `GoogleService-Info.plist`.
// Le code ci-dessous est alors compilé automatiquement grâce à `#if canImport(FirebaseAuth)` et
// peut être injecté à la place du fake dans `AppDependencies`.
//
// Points iOS importants (vs Android) :
//  - Pas de `callbackFlow` : on observe la session via `Auth.auth().addStateDidChangeListener`.
//  - Les API Firebase iOS sont déjà `async/await` → pas de `.await()` à la Kotlin.
//  - On traduit l'erreur avec `mapFirebaseAuthError(_:)` (fonction pure, testée séparément).

#if canImport(FirebaseAuth)
import FirebaseAuth
import Observation

@Observable
@MainActor
final class FirebaseAuthService: AuthService {
    @ObservationIgnored private var handle: AuthStateDidChangeListenerHandle?
    private(set) var currentUser: AuthUser?

    init() {
        currentUser = Auth.auth().currentUser.map(Self.map)
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.currentUser = user.map(Self.map)
        }
    }

    deinit {
        if let handle { Auth.auth().removeStateDidChangeListener(handle) }
    }

    func signUp(pseudo: String, email: String, password: String) async throws -> AuthUser {
        do {
            let result = try await Auth.auth().createUser(withEmail: email.trimmed, password: password)
            let change = result.user.createProfileChangeRequest()
            change.displayName = pseudo.trimmed
            try await change.commitChanges()
            return AuthUser(id: result.user.uid, pseudo: pseudo.trimmed, email: result.user.email)
        } catch {
            throw mapFirebaseAuthError((error as NSError).userInfo["FIRAuthErrorUserInfoNameKey"] as? String)
        }
    }

    func signIn(email: String, password: String) async throws -> AuthUser {
        do {
            let result = try await Auth.auth().signIn(withEmail: email.trimmed, password: password)
            return Self.map(result.user)
        } catch {
            throw mapFirebaseAuthError((error as NSError).userInfo["FIRAuthErrorUserInfoNameKey"] as? String)
        }
    }

    func signOut() { try? Auth.auth().signOut() }

    private static func map(_ user: FirebaseAuth.User) -> AuthUser {
        AuthUser(id: user.uid, pseudo: user.displayName, email: user.email)
    }
}

private extension String {
    var trimmed: String { trimmingCharacters(in: .whitespaces) }
}
#endif
