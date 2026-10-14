import SwiftUI

/// Variantes de bouton du kit (équivalent des `CcButtonKind` d'Android).
enum CCButtonKind {
    case filled        // CTA principal (fond primaire)
    case tonal         // fond primaryContainer
    case outlined      // bordure, fond transparent
    case outlinedError // bordure rouge (actions destructrices)
    case text          // lien textuel, sans fond
}

/// Bouton de marque. Gère un libellé, une icône SF Symbol optionnelle, et un état de chargement
/// (spinner + libellé « en cours »). Hauteur par défaut 52 pt.
///
/// PÉDAGO : on expose une API déclarative proche de Compose : `CCButton("Se connecter") { ... }`.
/// Le `kind` pilote les couleurs ; `loading` désactive le bouton et montre un `ProgressView`.
struct CCButton: View {
    let title: String
    var kind: CCButtonKind = .filled
    var systemImage: String? = nil
    var loading: Bool = false
    var fillWidth: Bool = false
    var height: CGFloat = Dimens.buttonHeight
    let action: () -> Void

    init(
        _ title: String,
        kind: CCButtonKind = .filled,
        systemImage: String? = nil,
        loading: Bool = false,
        fillWidth: Bool = false,
        height: CGFloat = Dimens.buttonHeight,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.kind = kind
        self.systemImage = systemImage
        self.loading = loading
        self.fillWidth = fillWidth
        self.height = height
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.sm) {
                if loading {
                    ProgressView().tint(foreground)
                } else if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title).font(.ccLabelLarge)
            }
            .frame(maxWidth: fillWidth ? .infinity : nil)
            .frame(height: kind == .text ? nil : height)
            .padding(.horizontal, kind == .text ? Spacing.sm : Spacing.lg)
            .foregroundStyle(foreground)
            .background(background, in: Capsule())
            .overlay(Capsule().strokeBorder(border, lineWidth: border == .clear ? 0 : 1.5))
        }
        .buttonStyle(.plain)
        .disabled(loading)
    }

    private var foreground: Color {
        switch kind {
        case .filled: CCColor.onPrimary
        case .tonal: CCColor.onPrimaryContainer
        case .outlined, .text: CCColor.primary
        case .outlinedError: CCColor.error
        }
    }
    private var background: Color {
        switch kind {
        case .filled: CCColor.primary
        case .tonal: CCColor.primaryContainer
        case .outlined, .outlinedError, .text: .clear
        }
    }
    private var border: Color {
        switch kind {
        case .outlined: CCColor.outline
        case .outlinedError: CCColor.error
        default: .clear
        }
    }
}

#Preview {
    VStack(spacing: Spacing.md) {
        CCButton("Se connecter", fillWidth: true) {}
        CCButton("Tonal", kind: .tonal, systemImage: "doc.on.doc") {}
        CCButton("Contour", kind: .outlined) {}
        CCButton("Se déconnecter", kind: .outlinedError, systemImage: "rectangle.portrait.and.arrow.right") {}
        CCButton("Lien", kind: .text) {}
        CCButton("Chargement", loading: true, fillWidth: true) {}
    }
    .padding()
    .background(CCColor.background)
}
