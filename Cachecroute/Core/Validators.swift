import Foundation

/// Validateurs de formulaire — **Swift pur** (aucune dépendance UIKit/SwiftUI), donc faciles à tester.
///
/// PÉDAGO : on sépare « est-ce valide ? » (ici) de « quel message afficher ? » (dans la vue). Ces
/// fonctions sont la cible directe de `ValidatorsTests`.
enum Validators {
    static let minPassword = 8
    static let maxPseudo = 30

    private static let emailRegex = /^[^@\s]+@[^@\s]+\.[^@\s]+$/

    /// Email : format simple (texte@texte.texte), insensible aux espaces de bord.
    static func isValidEmail(_ email: String) -> Bool {
        (try? emailRegex.wholeMatch(in: email.trimmingCharacters(in: .whitespaces))) != nil
    }

    /// Mot de passe : au moins 8 caractères.
    static func isValidPassword(_ password: String) -> Bool {
        password.count >= minPassword
    }

    /// Confirmation : identique au mot de passe (et non vide).
    static func passwordsMatch(_ password: String, _ confirmation: String) -> Bool {
        !password.isEmpty && password == confirmation
    }

    /// Pseudo : non vide (hors espaces) et au plus 30 caractères.
    static func isValidPseudo(_ pseudo: String) -> Bool {
        let trimmed = pseudo.trimmingCharacters(in: .whitespaces)
        return !trimmed.isEmpty && trimmed.count <= maxPseudo
    }
}
