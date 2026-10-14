import SwiftUI

/// Typographie de marque : **Young Serif** (titres, chiffres) et **Hanken Grotesk** (corps,
/// libellés). Les polices sont embarquées (`Resources/Fonts`) et déclarées dans `Info.plist`
/// (`UIAppFonts`). On les référence par leur nom PostScript.
///
/// PÉDAGO : on centralise l'échelle typographique ici, comme le `Type.kt` d'Android. Chaque style
/// Material (`headlineLarge`, `bodyLarge`…) a son équivalent `Font` iOS. Si une police manquait,
/// SwiftUI retomberait sur la police système — mais ici elles sont bien dans le bundle.
extension Font {
    // Young Serif — titres
    static let ccHeadlineLarge = serif(32)
    static let ccHeadlineMedium = serif(28)
    static let ccHeadlineSmall = serif(24)
    static let ccTitleLarge = serif(22)
    static let ccWordmark = serif(28)

    // Young Serif — chiffres
    static let ccPinDigit = serif(44)
    static let ccKeypadDigit = serif(30)

    // Hanken Grotesk — corps et libellés
    static let ccTitleMedium = hanken(16, "HankenGrotesk-SemiBold")
    static let ccBodyLarge = hanken(16, "HankenGrotesk-Regular")
    static let ccBodyMedium = hanken(14, "HankenGrotesk-Regular")
    static let ccLabelLarge = hanken(16, "HankenGrotesk-Bold")
    static let ccLabelSmall = hanken(12, "HankenGrotesk-Bold")

    private static func serif(_ size: CGFloat) -> Font {
        .custom("YoungSerif-Regular", size: size)
    }

    private static func hanken(_ size: CGFloat, _ name: String) -> Font {
        .custom(name, size: size)
    }
}
