import SwiftUI

/// Écran de Connexion. Les 5 états (vide / rempli / erreur de champ / erreur globale / chargement)
/// sont produits par le MÊME `AuthViewModel`.
///
/// PÉDAGO : la vue crée son ViewModel en `@State` à partir du service injecté. Au succès, le
/// ViewModel met à jour la session via le service ; `RootModel` voit `currentUser` changer et
/// remplace toute la branche `.auth` par l'accueil — navigation pilotée par l'état.
struct LoginView: View {
    let authService: AuthService
    let onNavigateToSignup: () -> Void
    @State private var vm: AuthViewModel

    init(authService: AuthService, onNavigateToSignup: @escaping () -> Void) {
        self.authService = authService
        self.onNavigateToSignup = onNavigateToSignup
        _vm = State(initialValue: AuthViewModel(authService: authService))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                AuthHeaderView()
                VStack(alignment: .leading, spacing: Spacing.md) {
                    Text("Content de vous revoir")
                        .font(.ccHeadlineLarge)
                        .foregroundStyle(CCColor.onBackground)
                    Text("Connectez-vous pour retrouver votre coloc.")
                        .font(.ccBodyLarge)
                        .foregroundStyle(CCColor.onSurfaceVariant)

                    if let globalError = vm.globalError {
                        ErrorCard(message: globalError)
                    }

                    CCTextField(label: "Email", text: $vm.email, systemImage: "envelope",
                                isError: vm.emailError != nil, supportingText: vm.emailError,
                                keyboard: .emailAddress, disabled: vm.isLoading)
                        .onChange(of: vm.email) { vm.emailError = nil; vm.globalError = nil }

                    CCSecureField(label: "Mot de passe", text: $vm.password,
                                  isError: vm.passwordError != nil, supportingText: vm.passwordError,
                                  disabled: vm.isLoading)
                        .onChange(of: vm.password) { vm.passwordError = nil; vm.globalError = nil }

                    CCButton(vm.isLoading ? "Connexion…" : "Se connecter",
                             loading: vm.isLoading, fillWidth: true) {
                        Task { await vm.submitLogin() }
                    }
                    .padding(.top, Spacing.sm)

                    HStack {
                        Spacer()
                        Text("Pas encore de compte ?")
                            .font(.ccBodyMedium).foregroundStyle(CCColor.onSurfaceVariant)
                        CCButton("Créer un compte", kind: .text, action: onNavigateToSignup)
                        Spacer()
                    }
                    .padding(.top, Spacing.sm)
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.top, Spacing.lg)
            }
        }
        .background(CCColor.background)
        .scrollDismissesKeyboard(.interactively)
    }
}

#Preview("Connexion") {
    LoginView(authService: FakeAuthService(), onNavigateToSignup: {})
}
