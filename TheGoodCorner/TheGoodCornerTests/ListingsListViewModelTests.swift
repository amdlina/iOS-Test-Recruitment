import XCTest
@testable import TheGoodCorner

@MainActor
final class ListingsListViewModelTests: XCTestCase {

    func testLoadSuccessPublishesLoadedItems() async {
        let viewModel = makeViewModel(
            listings: [.fixture(id: 1, title: "iphone 17")],
            categories: [CategoryItem(id: 1, name: "Tech")]
        )

        await viewModel.load()

        guard case .loaded(let items) = viewModel.state else {
            return XCTFail("Expected loaded state")
        }

        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items[0].title, "iphone 17")
        XCTAssertEqual(items[0].categoryName, "Tech")
        XCTAssertEqual(items[0].formattedPrice, "1100 €")
    }

    func testLoadPreservesAPIDisplayOrder() async {
        let listings = [
            Listing.fixture(id: 10, title: "Urgent first", isUrgent: true),
            Listing.fixture(id: 11, title: "Newest second"),
            Listing.fixture(id: 12, title: "Older third")
        ]

        let viewModel = makeViewModel(listings: listings, categories: [CategoryItem(id: 1, name: "Maison")])

        await viewModel.load()

        guard case .loaded(let items) = viewModel.state else {
            return XCTFail("Expected loaded state")
        }

        XCTAssertEqual(items.map(\.id), [10, 11, 12])
    }

    func testCategoryFilterKeepsOnlySelectedCategory() async {
        let listings = [
            Listing.fixture(id: 1, title: "Canapé", categoryId: 1),
            Listing.fixture(id: 2, title: "iPhone", categoryId: 2)
        ]

        let viewModel = makeViewModel(
            listings: listings,
            categories: [CategoryItem(id: 1, name: "Maison"), CategoryItem(id: 2, name: "Multimédia")]
        )

        await viewModel.load()
        viewModel.selectedCategoryId = 2

        guard case .loaded(let items) = viewModel.state else {
            return XCTFail("Expected loaded state")
        }

        XCTAssertEqual(items.map(\.title), ["iPhone"])
    }

    func testCategoryFilterPublishesEmptyWhenNoMatch() async {
        let viewModel = makeViewModel(
            listings: [.fixture(categoryId: 1)],
            categories: [CategoryItem(id: 1, name: "Maison"), CategoryItem(id: 2, name: "Multimédia")]
        )

        await viewModel.load()
        viewModel.selectedCategoryId = 2

        guard case .empty(let message) = viewModel.state else {
            return XCTFail("Expected empty state")
        }

        XCTAssertTrue(message.contains("catégorie"))
    }

    func testLoadFailurePublishesRecoverableError() async {
        let listingsRepository = MockListingsRepository(result: .failure(APIError.transport("Server offline")))
        let categoriesRepository = MockCategoriesRepository(result: .success([]))

        let viewModel = ListingsListViewModel(
            listingsRepository: listingsRepository,
            categoriesRepository: categoriesRepository,
            priceFormatter: MockPriceFormatter(),
            baseURL: URL(string: "http://localhost:8080")!
        )

        await viewModel.load()

        guard case .error(let message) = viewModel.state else {
            return XCTFail("Expected error state")
        }

        XCTAssertFalse(message.isEmpty)
    }

    private func makeViewModel(listings: [Listing], categories: [CategoryItem]) -> ListingsListViewModel {
        ListingsListViewModel(
            listingsRepository: MockListingsRepository(result: .success(.fixture(items: listings))),
            categoriesRepository: MockCategoriesRepository(result: .success(categories)),
            priceFormatter: MockPriceFormatter(),
            baseURL: URL(string: "http://localhost:8080")!
        )
    }
}
