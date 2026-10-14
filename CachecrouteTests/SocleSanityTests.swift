import Testing
@testable import Cachecroute

/// Test « sanity » du socle : il existe, il compile, et le module de test voit bien l'app.
/// (Les vrais tests arrivent avec les features : onboarding, auth, maison.)
struct SocleSanityTests {
    @Test func leSocleSeCompileEtSeTeste() {
        #expect(Bool(true))
    }
}
