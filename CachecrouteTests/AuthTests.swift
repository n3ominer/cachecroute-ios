import Testing
@testable import Cachecroute

struct ValidatorsTests {
    @Test func emailValide() {
        #expect(Validators.isValidEmail("thomas@foyer.fr"))
        #expect(Validators.isValidEmail("  margaux@coloc.io  "))
    }
    @Test func emailInvalide() {
        #expect(!Validators.isValidEmail(""))
        #expect(!Validators.isValidEmail("thomas"))
        #expect(!Validators.isValidEmail("thomas@foyer"))
    }
    @Test func motDePasseMin8() {
        #expect(!Validators.isValidPassword("court"))
        #expect(Validators.isValidPassword("motdepasse1"))
    }
    @Test func confirmationIdentique() {
        #expect(Validators.passwordsMatch("motdepasse1", "motdepasse1"))
        #expect(!Validators.passwordsMatch("motdepasse1", "autre"))
        #expect(!Validators.passwordsMatch("", ""))
    }
    @Test func pseudoNonVideMax30() {
        #expect(Validators.isValidPseudo("Thomas"))
        #expect(!Validators.isValidPseudo("   "))
        #expect(!Validators.isValidPseudo(String(repeating: "x", count: 31)))
    }
}

struct AuthErrorMapperTests {
    @Test func mappingDesCodes() {
        #expect(mapFirebaseAuthError("ERROR_INVALID_EMAIL") == .invalidEmail)
        #expect(mapFirebaseAuthError("ERROR_WRONG_PASSWORD") == .invalidCredentials)
        #expect(mapFirebaseAuthError("ERROR_USER_NOT_FOUND") == .invalidCredentials)
        #expect(mapFirebaseAuthError("ERROR_EMAIL_ALREADY_IN_USE") == .emailAlreadyInUse)
        #expect(mapFirebaseAuthError("ERROR_WEAK_PASSWORD") == .weakPassword)
        #expect(mapFirebaseAuthError("ERROR_NETWORK_REQUEST_FAILED") == .network)
        #expect(mapFirebaseAuthError("ERROR_TOO_MANY_REQUESTS") == .tooManyAttempts)
        #expect(mapFirebaseAuthError(nil) == .unknown)
        #expect(mapFirebaseAuthError("ERROR_AUTRE") == .unknown)
    }
}

@MainActor
struct AuthViewModelTests {
    /// S1-10 — connexion réussie : émet l'événement, session ouverte, pas d'erreur.
    @Test func connexionReussie() async {
        let service = FakeAuthService()
        let vm = AuthViewModel(authService: service)
        var authenticated = false
        vm.onAuthenticated = { authenticated = true }

        vm.email = "demo@cachecrout.app"
        vm.password = "motdepasse1"
        await vm.submitLogin()

        #expect(authenticated)
        #expect(service.currentUser != nil)
        #expect(vm.isLoading == false)
        #expect(vm.globalError == nil)
    }

    /// Mauvais mot de passe : erreur globale, pas d'événement.
    @Test func connexionMauvaisMotDePasse() async {
        let vm = AuthViewModel(authService: FakeAuthService())
        vm.email = "demo@cachecrout.app"
        vm.password = "mauvaismdp"
        await vm.submitLogin()
        #expect(vm.globalError != nil)
        #expect(vm.isLoading == false)
    }

    /// Email invalide : erreur de champ, le service n'est jamais appelé (pas de session).
    @Test func connexionEmailInvalideBloqueAvantLeService() async {
        let service = FakeAuthService()
        let vm = AuthViewModel(authService: service)
        vm.email = "pas-un-email"
        vm.password = "motdepasse1"
        await vm.submitLogin()
        #expect(vm.emailError != nil)
        #expect(service.currentUser == nil)
    }

    /// Inscription réussie.
    @Test func inscriptionReussie() async {
        let service = FakeAuthService()
        let vm = AuthViewModel(authService: service)
        vm.pseudo = "Margaux"
        vm.email = "margaux@coloc.io"
        vm.password = "motdepasse1"
        vm.confirmPassword = "motdepasse1"
        await vm.submitSignup()
        #expect(service.currentUser?.pseudo == "Margaux")
        #expect(vm.globalError == nil)
    }
}
