import SwiftUI

/// Espacements (points). Équivalent iOS des `Spacing.*` d'Android (dp → pt, même échelle 4/8).
enum Spacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let smPlus: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
}

/// Rayons d'arrondi (points).
enum CornerRadius {
    static let extraSmall: CGFloat = 8
    static let small: CGFloat = 12
    static let medium: CGFloat = 20
    static let large: CGFloat = 28
    static let extraLarge: CGFloat = 36
}

/// Dimensions fixes du design system.
enum Dimens {
    static let touchTarget: CGFloat = 48
    static let buttonHeight: CGFloat = 52
    static let buttonHeightHero: CGFloat = 56
    static let fieldHeight: CGFloat = 56
    static let keypadKey: CGFloat = 68
    static let pinTileWidth: CGFloat = 64
    static let pinTileHeight: CGFloat = 80
    static let illustrationOnboarding: CGFloat = 220
    static let illustrationScene: CGFloat = 180
    static let illustrationObject: CGFloat = 96
}

/// Forme « héros » de l'en-tête d'authentification : rectangle aux coins INFÉRIEURS arrondis (28).
///
/// PÉDAGO : en SwiftUI on crée une forme sur mesure en implémentant `Shape`. `UnevenRoundedRectangle`
/// (iOS 16+) fait exactement ça sans dessiner le `Path` à la main — on arrondit seulement le bas.
struct AuthHeroShape: Shape {
    func path(in rect: CGRect) -> Path {
        UnevenRoundedRectangle(
            bottomLeadingRadius: CornerRadius.large,
            bottomTrailingRadius: CornerRadius.large
        ).path(in: rect)
    }
}
