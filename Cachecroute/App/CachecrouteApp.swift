import SwiftUI

/// Point d'entrée de l'application (SwiftUI App lifecycle).
///
/// PÉDAGO : on fabrique ici la racine de composition (`AppDependencies`) — UNE fois — et on
/// l'injecte vers le bas. C'est le pendant iOS de `@HiltAndroidApp` : l'endroit unique où le
/// graphe de dépendances prend vie. `@State` garantit que le conteneur survit aux recompositions.
@main
struct CachecrouteApp: App {
    @State private var dependencies = AppDependencies()

    var body: some Scene {
        WindowGroup {
            AppRootView(dependencies: dependencies)
        }
    }
}
