import SwiftUI

@main
struct TheGoodCornerApp: App {
    private let environment = AppEnvironment.live

    var body: some Scene {
        WindowGroup {
            ListingsListContainer(
                environment: environment
            )
        }
    }
}
