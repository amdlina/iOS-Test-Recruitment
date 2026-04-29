import SwiftUI

@main
struct TheGoodCornerApp: App {
    private let environment = AppEnvironment.live

    var body: some Scene {
        WindowGroup {
            ListingsListView(
                viewModel: ListingsListViewModel(
                    listingsRepository: environment.listingsRepository,
                    categoriesRepository: environment.categoriesRepository
                )
            )
        }
    }
}
