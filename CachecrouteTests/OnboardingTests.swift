import Testing
import Foundation
@testable import Cachecroute

/// Faux store écrit à la main (pas de framework de mock : plus simple à lire). Sert aux tests du
/// `RootModel`.
@MainActor
final class FakeOnboardingStore: OnboardingStore {
    var isReady: Bool
    private(set) var hasSeenOnboarding: Bool

    init(seen: Bool = false, ready: Bool = true) {
        self.hasSeenOnboarding = seen
        self.isReady = ready
    }

    func markSeen() { hasSeenOnboarding = true }
}

@MainActor
struct OnboardingStoreTests {
    /// S1-01 — le store UserDefaults lit/écrit bien le drapeau (UserDefaults jetable).
    private func makeStore() -> UserDefaultsOnboardingStore {
        let suite = UserDefaults(suiteName: "test-\(UUID().uuidString)")!
        return UserDefaultsOnboardingStore(defaults: suite)
    }

    @Test func parDefautOnboardingNonVu() {
        #expect(makeStore().hasSeenOnboarding == false)
    }

    @Test func apresMarkSeenIlEstVu() {
        let store = makeStore()
        store.markSeen()
        #expect(store.hasSeenOnboarding == true)
    }
}

@MainActor
struct RootModelTests {
    /// S1-02 — tableau de vérité du `RootModel` (version onboarding).
    @Test func onboardingNonVuDemarreSurOnboarding() {
        let model = RootModel(onboardingStore: FakeOnboardingStore(seen: false))
        #expect(model.startDestination == .onboarding)
    }

    @Test func onboardingVuDemarreSurHome() {
        let model = RootModel(onboardingStore: FakeOnboardingStore(seen: true))
        #expect(model.startDestination == .home)
    }

    @Test func pasPretResteSurLoading() {
        let model = RootModel(onboardingStore: FakeOnboardingStore(seen: true, ready: false))
        #expect(model.startDestination == .loading)
    }

    @Test func markOnboardingSeenFaitPasserAHome() {
        let store = FakeOnboardingStore(seen: false)
        let model = RootModel(onboardingStore: store)
        model.markOnboardingSeen()
        #expect(model.startDestination == .home)
    }
}
