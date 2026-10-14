import SwiftUI

/// Grand en-tête de page (titre serif + sous-titre), utilisé par l'écran de choix de maison.
/// Équivalent du `CcLargeTopBar` d'Android, mais pensé iOS : il vit DANS le contenu, au-dessus,
/// pendant que la `NavigationStack` fournit la barre système et le bouton retour quand il en faut.
struct CCLargeHeader: View {
    let title: String
    var subtitle: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(title)
                .font(.ccHeadlineLarge)
                .foregroundStyle(CCColor.onBackground)
            if let subtitle {
                Text(subtitle)
                    .font(.ccBodyLarge)
                    .foregroundStyle(CCColor.onSurfaceVariant)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Spacing.lg)
        .padding(.top, Spacing.lg)
        .padding(.bottom, Spacing.md)
    }
}
