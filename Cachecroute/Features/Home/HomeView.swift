import SwiftUI

/// Accueil (placeholder) : « Bonjour {pseudo} » + bouton « Se déconnecter » (avec confirmation).
/// Les onglets Stock/Courses/Chat/Réglages sont hors périmètre.
struct HomeView: View {
    let authService: AuthService
    @State private var model: HomeModel
    @State private var showLogoutDialog = false

    init(authService: AuthService) {
        self.authService = authService
        _model = State(initialValue: HomeModel(authService: authService))
    }

    var body: some View {
        VStack(spacing: Spacing.sm) {
            Text("Bonjour \(model.displayName ?? "") 👋")
                .font(.ccHeadlineLarge)
                .foregroundStyle(CCColor.onBackground)
                .multilineTextAlignment(.center)
            Text("Votre espace coloc arrive bientôt.")
                .font(.ccBodyLarge)
                .foregroundStyle(CCColor.onSurfaceVariant)
                .multilineTextAlignment(.center)

            CCButton("Se déconnecter", kind: .outlinedError,
                     systemImage: "rectangle.portrait.and.arrow.right") {
                showLogoutDialog = true
            }
            .padding(.top, Spacing.xl)
        }
        .padding(.horizontal, Spacing.lg)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CCColor.background)
        .confirmationDialog("Se déconnecter ?", isPresented: $showLogoutDialog, titleVisibility: .visible) {
            Button("Se déconnecter", role: .destructive) { model.signOut() }
            Button("Annuler", role: .cancel) {}
        } message: {
            Text("Vous devrez saisir à nouveau vos identifiants.")
        }
    }
}

#Preview("Accueil – clair") {
    HomeView(authService: { let s = FakeAuthService(); return s }())
}
