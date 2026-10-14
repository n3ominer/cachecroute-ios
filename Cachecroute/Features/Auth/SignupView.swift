import SwiftUI

/// Écran d'Inscription. Mêmes zones que la Connexion, 4 champs. Même `AuthViewModel` (instance propre).
struct SignupView: View {
    let authService: AuthService
    @State private var vm: AuthViewModel

    init(authService: AuthService) {
        self.authService = authService
        _vm = State(initialValue: AuthViewModel(authService: authService))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                AuthHeaderView()
                VStack(alignment: .leading, spacing: Spacing.md) {
                    Text("Créer un compte")
                        .font(.ccHeadlineLarge)
                        .foregroundStyle(CCColor.onBackground)

                    if let globalError = vm.globalError {
                        ErrorCard(message: globalError)
                    }

                    CCTextField(label: "Pseudo", text: $vm.pseudo, systemImage: "person",
                                isError: vm.pseudoError != nil,
                                supportingText: vm.pseudoError ?? "Ce nom sera visible par la coloc.",
                                disabled: vm.isLoading)
                        .onChange(of: vm.pseudo) { vm.pseudoError = nil; vm.globalError = nil }

                    CCTextField(label: "Email", text: $vm.email, systemImage: "envelope",
                                isError: vm.emailError != nil, supportingText: vm.emailError,
                                keyboard: .emailAddress, disabled: vm.isLoading)
                        .onChange(of: vm.email) { vm.emailError = nil; vm.globalError = nil }

                    CCSecureField(label: "Mot de passe", text: $vm.password,
                                  isError: vm.passwordError != nil,
                                  supportingText: vm.passwordError ?? "8 caractères minimum.",
                                  disabled: vm.isLoading)
                        .onChange(of: vm.password) { vm.passwordError = nil; vm.globalError = nil }

                    CCSecureField(label: "Confirmer le mot de passe", text: $vm.confirmPassword,
                                  isError: vm.confirmError != nil, supportingText: vm.confirmError,
                                  disabled: vm.isLoading)
                        .onChange(of: vm.confirmPassword) { vm.confirmError = nil; vm.globalError = nil }

                    CCButton(vm.isLoading ? "Création…" : "Créer mon compte",
                             loading: vm.isLoading, fillWidth: true) {
                        Task { await vm.submitSignup() }
                    }
                    .padding(.top, Spacing.sm)
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.top, Spacing.lg)
            }
        }
        .background(CCColor.background)
        .navigationTitle("Inscription")
        .navigationBarTitleDisplayMode(.inline)
        .scrollDismissesKeyboard(.interactively)
    }
}

#Preview("Inscription") {
    NavigationStack { SignupView(authService: FakeAuthService()) }
}
