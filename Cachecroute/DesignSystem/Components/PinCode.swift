import SwiftUI

/// Rangée de 4 tuiles affichant un code (64 × 80). Tuile pleine = chiffre serif ; vide = contour.
/// En erreur, les tuiles passent au rouge.
struct PinRow: View {
    let code: String
    var hasError: Bool = false
    var length: Int = 4

    var body: some View {
        HStack(spacing: Spacing.smPlus) {
            ForEach(0..<length, id: \.self) { index in
                tile(digit(at: index))
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Code à \(length) chiffres")
        .accessibilityValue(code.isEmpty ? "vide" : code.map(String.init).joined(separator: " "))
    }

    private func digit(at index: Int) -> String? {
        index < code.count ? String(Array(code)[index]) : nil
    }

    private func tile(_ value: String?) -> some View {
        let filled = value != nil
        let stroke = hasError ? CCColor.error : (filled ? CCColor.primary : CCColor.outlineVariant)
        return Text(value ?? "")
            .font(.ccPinDigit)
            .foregroundStyle(hasError ? CCColor.error : CCColor.onBackground)
            .frame(width: Dimens.pinTileWidth, height: Dimens.pinTileHeight)
            .background(
                CCColor.surfaceContainerLow,
                in: RoundedRectangle(cornerRadius: CornerRadius.small)
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.small)
                    .strokeBorder(stroke, lineWidth: filled || hasError ? 2 : 1.5)
            )
    }
}

/// Pavé numérique maison (jamais le clavier système). 1–9 puis ⌫ / 0 / ✓.
///
/// PÉDAGO : le pavé est « bête » — il ne connaît pas le code, il remonte juste des événements
/// (`onDigit`, `onBackspace`, `onConfirm`) au ViewModel, qui, lui, détient l'état.
struct NumericKeypad: View {
    var onDigit: (Character) -> Void
    var onBackspace: () -> Void
    var onConfirm: () -> Void
    var confirmEnabled: Bool

    private let columns = Array(repeating: GridItem(.flexible(), spacing: Spacing.md), count: 3)

    var body: some View {
        LazyVGrid(columns: columns, spacing: Spacing.md) {
            ForEach(1...9, id: \.self) { n in
                key(label: "\(n)") { onDigit(Character("\(n)")) }
            }
            iconKey(systemImage: "delete.left", action: onBackspace)
                .accessibilityLabel("Effacer")
            key(label: "0") { onDigit("0") }
            iconKey(systemImage: "checkmark", tint: CCColor.onPrimary, background: CCColor.primary, action: onConfirm)
                .opacity(confirmEnabled ? 1 : 0.4)
                .disabled(!confirmEnabled)
                .accessibilityLabel("Valider")
        }
        .padding(.horizontal, Spacing.lg)
    }

    private func key(label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.ccKeypadDigit)
                .foregroundStyle(CCColor.onSurface)
                .frame(maxWidth: .infinity)
                .frame(height: Dimens.keypadKey)
                .background(CCColor.surfaceContainerHigh, in: Circle())
        }
        .buttonStyle(.plain)
    }

    private func iconKey(
        systemImage: String,
        tint: Color = CCColor.onSurface,
        background: Color = .clear,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(tint)
                .frame(maxWidth: .infinity)
                .frame(height: Dimens.keypadKey)
                .background(background, in: Circle())
        }
        .buttonStyle(.plain)
    }
}

/// Effet de secousse horizontale, déclenché quand `animatableData` varie.
struct ShakeEffect: GeometryEffect {
    var travel: CGFloat = 8
    var shakes: CGFloat = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = travel * sin(animatableData * .pi * shakes)
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}

extension View {
    /// Secoue la vue à chaque incrément de `trigger` (utilisé pour un code invalide).
    func errorShake(_ trigger: Int) -> some View {
        modifier(ShakeOnChange(trigger: trigger))
    }
}

private struct ShakeOnChange: ViewModifier {
    let trigger: Int
    @State private var amount: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .modifier(ShakeEffect(animatableData: amount))
            .onChange(of: trigger) { _, _ in
                amount = 0
                withAnimation(.linear(duration: 0.4)) { amount = 1 }
            }
    }
}
