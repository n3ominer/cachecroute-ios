import Foundation
import Observation

/// ViewModel de l'accueil (placeholder). Fournit le pseudo à afficher et la déconnexion.
///
/// PÉDAGO : `displayName` est un instantané (le pseudo ne change pas pendant la session). La
/// déconnexion appelle le service ; `RootModel` voit la session passer à `nil` et rebascule vers
/// l'écran de connexion — on ne « navigue » pas à la main.
@Observable
@MainActor
final class HomeModel {
    @ObservationIgnored private let authService: AuthService

    init(authService: AuthService) {
        self.authService = authService
    }

    var displayName: String? {
        authService.currentUser?.pseudo ?? authService.currentUser?.email
    }

    func signOut() {
        authService.signOut()
    }
}
