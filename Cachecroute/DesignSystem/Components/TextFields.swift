import SwiftUI

/// Champ de texte de marque : libellé flottant, icône SF Symbol optionnelle, état d'erreur et
/// texte d'aide (ou message d'erreur) sous le champ.
///
/// PÉDAGO : on encapsule le `TextField` système dans un conteneur stylé (hauteur 56, bordure qui
/// vire au rouge en erreur). L'API reprend celle d'Android (`value`, `isError`, `supportingText`).
struct CCTextField: View {
    let label: String
    @Binding var text: String
    var systemImage: String? = nil
    var isError: Bool = false
    var supportingText: String? = nil
    var keyboard: UIKeyboardType = .default
    var submitLabel: SubmitLabel = .next
    var disabled: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            HStack(spacing: Spacing.sm) {
                if let systemImage {
                    Image(systemName: systemImage).foregroundStyle(CCColor.onSurfaceVariant)
                }
                TextField(label, text: $text)
                    .font(.ccBodyLarge)
                    .keyboardType(keyboard)
                    .submitLabel(submitLabel)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(keyboard == .emailAddress ? .never : .sentences)
                    .disabled(disabled)
            }
            .padding(.horizontal, Spacing.md)
            .frame(height: Dimens.fieldHeight)
            .background(CCColor.surfaceContainerLow, in: RoundedRectangle(cornerRadius: CornerRadius.small))
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.small)
                    .strokeBorder(isError ? CCColor.error : CCColor.outlineVariant, lineWidth: 1.5)
            )
            if let supportingText {
                Text(supportingText)
                    .font(.ccBodyMedium)
                    .foregroundStyle(isError ? CCColor.error : CCColor.onSurfaceVariant)
                    .padding(.leading, Spacing.xs)
            }
        }
    }
}

/// Champ mot de passe : masqué par défaut, avec bouton œil pour révéler.
struct CCSecureField: View {
    let label: String
    @Binding var text: String
    var isError: Bool = false
    var supportingText: String? = nil
    var disabled: Bool = false
    @State private var revealed = false

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            HStack(spacing: Spacing.sm) {
                Image(systemName: "lock").foregroundStyle(CCColor.onSurfaceVariant)
                Group {
                    if revealed {
                        TextField(label, text: $text)
                    } else {
                        SecureField(label, text: $text)
                    }
                }
                .font(.ccBodyLarge)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .disabled(disabled)
                Button { revealed.toggle() } label: {
                    Image(systemName: revealed ? "eye.slash" : "eye")
                        .foregroundStyle(CCColor.onSurfaceVariant)
                }
                .accessibilityLabel(revealed ? "Masquer le mot de passe" : "Afficher le mot de passe")
            }
            .padding(.horizontal, Spacing.md)
            .frame(height: Dimens.fieldHeight)
            .background(CCColor.surfaceContainerLow, in: RoundedRectangle(cornerRadius: CornerRadius.small))
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.small)
                    .strokeBorder(isError ? CCColor.error : CCColor.outlineVariant, lineWidth: 1.5)
            )
            if let supportingText {
                Text(supportingText)
                    .font(.ccBodyMedium)
                    .foregroundStyle(isError ? CCColor.error : CCColor.onSurfaceVariant)
                    .padding(.leading, Spacing.xs)
            }
        }
    }
}
