import SwiftUI

/// Bandeau d'authentification : rectangle aux coins inférieurs arrondis (`AuthHeroShape`), fond
/// `primaryContainer`, logo + nom de marque. Inclut l'inset de barre d'état (safe area top).
struct AuthHeaderView: View {
    var body: some View {
        HStack(spacing: Spacing.smPlus) {
            Image("logo_mark")
                .resizable()
                .scaledToFit()
                .frame(width: 56, height: 56)
                .accessibilityHidden(true)
            Text("CacheCroûte")
                .font(.ccWordmark)
                .foregroundStyle(CCColor.onPrimaryContainer)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 144)
        .background(CCColor.primaryContainer, in: AuthHeroShape())
        .ignoresSafeArea(edges: .top)
    }
}

#Preview { AuthHeaderView() }
