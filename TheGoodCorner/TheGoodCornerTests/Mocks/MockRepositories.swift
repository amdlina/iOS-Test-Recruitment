import Foundation
@testable import TheGoodCorner

final class MockListingsRepository: ListingsRepositoryProtocol {
    var result: Result<ListingsResponse, Error>

    init(result: Result<ListingsResponse, Error>) {
        self.result = result
    }

    func fetchListings(page: Int?, limit: Int?, query: String?) async throws -> ListingsResponse {
        try result.get()
    }
}

final class MockCategoriesRepository: CategoriesRepositoryProtocol {
    var result: Result<[CategoryItem], Error>

    init(result: Result<[CategoryItem], Error>) {
        self.result = result
    }

    func fetchCategories() async throws -> [CategoryItem] {
        try result.get()
    }
}

struct MockPriceFormatter: PriceFormatting {
    func format(price: Int) -> String {
        "\(price) €"
    }
}

extension Listing {
    static func fixture(
        id: Int = 1,
        title: String = "iphone 17",
        categoryId: Int = 1,
        price: Int = 1100,
        smallImagePath: String? = "/images/1.jpg",
        creationDate: Date = Date(timeIntervalSince1970: 1_700_000_000),
        isUrgent: Bool = false,
        description: String? = "Très bon état",
    ) -> Listing {
        Listing(
            id: id,
            title: title,
            categoryId: categoryId,
            price: price,
            imagesUrl: ImagesURL(small: smallImagePath, thumb: nil),
            creationDate: creationDate,
            isUrgent: isUrgent,
            description: description,
        )
    }
}

extension ListingsResponse {
    static func fixture(items: [Listing]) -> ListingsResponse {
        ListingsResponse(items: items, total: items.count, page: 1, limit: items.count, hasMore: false)
    }
}
