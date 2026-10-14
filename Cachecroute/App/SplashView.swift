import SwiftUI

/// Écran de lancement de marque, affiché tant que `RootModel` renvoie `.loading`.
///
/// PÉDAGO : iOS affiche d'abord le launch screen statique (`Info.plist` → `UILaunchScreen`), puis
/// cette vue prend le relais tant qu'on ne connaît pas la destination. Comme nos sources d'état
/// (UserDefaults) sont synchrones, ce passage est quasi instantané — mais l'architecture reste
/// prête pour une source ASYNCHRONE (session Firebase en séance suivante).
struct SplashView: View {
    var body: some View {
        VStack(spacing: Spacing.md) {
            Image("logo_mark")
                .resizable()
                .scaledToFit()
                .frame(width: 96, height: 96)
            Text("CacheCroûte")
                .font(.ccWordmark)
                .foregroundStyle(CCColor.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CCColor.background)
    }
}

#Preview { SplashView() }
