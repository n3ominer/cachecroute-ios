import SwiftUI

/// Écran d'accueil du SOCLE : neutre, juste de quoi vérifier que l'app se lance, que le thème
/// (couleurs, polices de marque) fonctionne. Les vraies features le remplaceront
/// (« Bonjour {pseudo} », puis nom + code de maison).
struct HomeView: View {
    var body: some View {
        VStack(spacing: Spacing.sm) {
            Text("CacheCroûte")
                .font(.ccHeadlineLarge)
                .foregroundStyle(CCColor.primary)
            Text("Le stock de la coloc, sans prise de tête.")
                .font(.ccBodyLarge)
                .foregroundStyle(CCColor.onSurfaceVariant)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, Spacing.lg)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CCColor.background)
    }
}

#Preview("Accueil – clair") {
    HomeView()
}

#Preview("Accueil – sombre") {
    HomeView().preferredColorScheme(.dark)
}
