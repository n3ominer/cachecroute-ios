import SwiftUI

/// Point d'entrée de l'application (SwiftUI App lifecycle).
///
/// PÉDAGO — SOCLE : dans le socle, l'app affiche directement l'accueil. Il n'y a pas encore de
/// décision « quel écran au démarrage ? ». Cette décision (onboarding vu ? connecté ? maison ?)
/// arrivera en séance 1 avec un `RootModel`, et c'est `AppRootView` qui l'orchestrera.
///
/// Contrairement à Android (une `Activity` + `installSplashScreen`), iOS utilise le cycle de vie
/// `App` + `Scene`. L'« écran de lancement » statique est décrit dans `Info.plist` (`UILaunchScreen`).
@main
struct CachecrouteApp: App {
    var body: some Scene {
        WindowGroup {
            AppRootView()
        }
    }
}
