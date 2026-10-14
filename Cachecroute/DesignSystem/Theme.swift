import SwiftUI

/// Palette de marque « Fournil » (direction A du design system CacheCrout).
///
/// PÉDAGO : plutôt qu'un Asset Catalog avec un fichier par couleur, on déclare ici chaque rôle
/// comme une couleur DYNAMIQUE (clair/sombre) via un `UIColor` à fournisseur de trait. C'est
/// compact, versionnable, et ça bascule automatiquement avec l'apparence du système — l'équivalent
/// iOS du double thème Material (clair/sombre) d'Android.
enum CCColor {
    // MARK: Primaire / secondaire / tertiaire
    static let primary = dyn(0xA5401A, 0xFFB690)
    static let onPrimary = dyn(0xFFFFFF, 0x552000)
    static let primaryContainer = dyn(0xFFDCC8, 0x6E2A0B)
    static let onPrimaryContainer = dyn(0x6B2308, 0xFFDCC8)

    static let secondary = dyn(0x566B2E, 0xBFD48C)
    static let onSecondary = dyn(0xFFFFFF, 0x2A3800)
    static let secondaryContainer = dyn(0xDDE8BC, 0x3F4F1E)
    static let onSecondaryContainer = dyn(0x26330A, 0xDDE8BC)

    static let tertiary = dyn(0x8A5A00, 0xF2C36A)
    static let onTertiaryContainer = dyn(0x4A3000, 0xFFE0A6)
    static let tertiaryContainer = dyn(0xFFE0A6, 0x5A3E00)

    // MARK: Erreur
    static let error = dyn(0xB3261E, 0xFFB4AB)
    static let onError = dyn(0xFFFFFF, 0x5C0E0A)
    static let errorContainer = dyn(0xFADAD5, 0x6B1A15)
    static let onErrorContainer = dyn(0x5C0E0A, 0xFFDAD6)

    // MARK: Fonds et surfaces
    static let background = dyn(0xFFF8EE, 0x1F1712)
    static let onBackground = dyn(0x2B1E14, 0xF5E9D9)
    static let surface = dyn(0xFFF8EE, 0x1F1712)
    static let onSurface = dyn(0x2B1E14, 0xF5E9D9)
    static let surfaceVariant = dyn(0xF3E7D3, 0x3A2E24)
    static let onSurfaceVariant = dyn(0x65533F, 0xCDBBA5)
    static let outline = dyn(0x8C7B67, 0x9C8B78)
    static let outlineVariant = dyn(0xE6D6BC, 0x4A3B2E)

    static let surfaceContainerLowest = dyn(0xFFFFFF, 0x170F0B)
    static let surfaceContainerLow = dyn(0xFFFDF8, 0x2A2019)
    static let surfaceContainer = dyn(0xF8EBD8, 0x30251C)
    static let surfaceContainerHigh = dyn(0xF3E7D3, 0x3A2E24)
    static let surfaceContainerHighest = dyn(0xEBDCC4, 0x45372B)

    // MARK: Rôles étendus (succès, halo…)
    static let success = dyn(0x2F6B35, 0x9BD49A)
    static let successContainer = dyn(0xD9EDCF, 0x24421F)
    static let onSuccessContainer = dyn(0x1A3D1E, 0xD3EFC9)
    static let halo = dyn(0xFBE6C8, 0x3A2C21)

    // MARK: Fabrique de couleur dynamique
    private static func dyn(_ light: UInt32, _ dark: UInt32) -> Color {
        Color(UIColor { trait in
            UIColor(rgb: trait.userInterfaceStyle == .dark ? dark : light)
        })
    }
}

private extension UIColor {
    convenience init(rgb: UInt32) {
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255,
            green: CGFloat((rgb >> 8) & 0xFF) / 255,
            blue: CGFloat(rgb & 0xFF) / 255,
            alpha: 1
        )
    }
}
