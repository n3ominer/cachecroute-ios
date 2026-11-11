import SwiftUI

/// Une page d'onboarding : illustration + titre + corps.
private struct OnboardingPage: Identifiable {
    let id = UUID()
    let illustration: String
    let title: String
    let body: String
}

private let onboardingPages: [OnboardingPage] = [
    .init(illustration: "ill_onboarding_stock",
          title: "Votre stock, toujours à jour",
          body: "Scannez, ajoutez, et voyez d'un coup d'œil ce qu'il reste dans le placard."),
    .init(illustration: "ill_onboarding_courses",
          title: "La liste de courses partagée",
          body: "Chacun ajoute ce qui manque. Fini les doublons et les oublis au magasin."),
    .init(illustration: "ill_onboarding_house",
          title: "Toute la coloc, au même endroit",
          body: "Rejoignez votre maison avec un code et partagez le quotidien.")
]

/// Onboarding : 3 pages balayables. « Passer » et « Commencer » terminent ; « Suivant » avance.
///
/// PÉDAGO :
///  - `TabView` + `.tabViewStyle(.page)` est l'équivalent iOS du `HorizontalPager` de Compose.
///  - `@State private var page` conserve la page courante à travers les recompositions (comme
///    `rememberPagerState`).
///  - State hoisting : l'écran NE SAIT PAS ce que « terminer » veut dire. Il remonte l'info via le
///    callback `onFinished`. C'est le parent (la racine) qui décide : marquer le drapeau + afficher
///    l'accueil. L'écran reste réutilisable et prévisualisable (`onFinished: {}`).
struct OnboardingView: View {
    let onFinished: () -> Void
    @State private var page = 0

    private var isLastPage: Bool { page == onboardingPages.count - 1 }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                CCButton("Passer", kind: .text) { onFinished() }
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.top, Spacing.sm)

            TabView(selection: $page) {
                ForEach(Array(onboardingPages.enumerated()), id: \.offset) { index, item in
                    pageContent(item).tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: page)

            PageIndicator(count: onboardingPages.count, current: page)
                .padding(.vertical, Spacing.lg)

            CCButton(isLastPage ? "Commencer" : "Suivant", fillWidth: true, height: Dimens.buttonHeightHero) {
                if isLastPage {
                    onFinished()
                } else {
                    withAnimation { page += 1 }
                }
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.bottom, Spacing.xl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CCColor.background)
    }

    private func pageContent(_ item: OnboardingPage) -> some View {
        VStack(spacing: Spacing.xl) {
            Illustration(item.illustration, size: Dimens.illustrationOnboarding)
            VStack(spacing: Spacing.smPlus) {
                Text(item.title)
                    .font(.ccHeadlineLarge)
                    .foregroundStyle(CCColor.onBackground)
                    .multilineTextAlignment(.center)
                Text(item.body)
                    .font(.ccBodyLarge)
                    .foregroundStyle(CCColor.onSurfaceVariant)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, Spacing.lg)
    }
}

/// Indicateur de pages : capsule active 24 × 8, points inactifs 8 × 8.
private struct PageIndicator: View {
    let count: Int
    let current: Int

    var body: some View {
        HStack(spacing: Spacing.sm) {
            ForEach(0..<count, id: \.self) { index in
                Capsule()
                    .fill(index == current ? CCColor.primary : CCColor.outline.opacity(0.55))
                    .frame(width: index == current ? 24 : 8, height: 8)
                    .animation(.spring(duration: 0.3), value: current)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Page \(current + 1) sur \(count)")
    }
}

#Preview("Onboarding – clair") {
    OnboardingView(onFinished: {})
}

#Preview("Onboarding – sombre") {
    OnboardingView(onFinished: {}).preferredColorScheme(.dark)
}
