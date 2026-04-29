import SwiftUI

struct ListingsListContainer: View {

    @StateObject private var listingsViewModel: ListingsListViewModel
    @StateObject private var draftViewModel: ClassifiedAdDraftViewModel

    init(environment: AppEnvironment) {
        _listingsViewModel = StateObject(
            wrappedValue: ListingsListViewModel(
                listingsRepository: environment.listingsRepository,
                categoriesRepository: environment.categoriesRepository
            )
        )
    }

    var body: some View {
        ListingsListView(
            viewModel: listingsViewModel
        )
    }
}
