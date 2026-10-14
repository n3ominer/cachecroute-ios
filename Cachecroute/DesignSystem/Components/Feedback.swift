import SwiftUI

/// Carte d'erreur globale (fond `errorContainer`, icône + message). Équivalent de l'`ErrorCard`
/// d'Android. Annoncée comme une alerte par VoiceOver.
struct ErrorCard: View {
    let message: String

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.sm) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(CCColor.error)
            Text(message)
                .font(.ccBodyMedium)
                .foregroundStyle(CCColor.onErrorContainer)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(Spacing.md)
        .background(CCColor.errorContainer, in: RoundedRectangle(cornerRadius: CornerRadius.small))
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isStaticText)
    }
}

/// Illustration vectorielle du kit (asset catalog, variantes clair/sombre automatiques).
struct Illustration: View {
    let name: String
    var size: CGFloat

    init(_ name: String, size: CGFloat) {
        self.name = name
        self.size = size
    }

    var body: some View {
        Image(name)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .accessibilityHidden(true)
    }
}
