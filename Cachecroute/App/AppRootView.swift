import SwiftUI

/// Racine de l'interface.
///
/// PÉDAGO — SOCLE : pour l'instant, une seule destination (l'accueil). Les séances brancheront ici
/// l'aiguillage de départ (onboarding / auth / maison / accueil) piloté par `RootModel`, à la
/// manière du `when(startDestination)` d'Android — mais de façon pilotée par l'état, idiome SwiftUI.
struct AppRootView: View {
    var body: some View {
        HomeView()
    }
}

#Preview {
    AppRootView()
}
