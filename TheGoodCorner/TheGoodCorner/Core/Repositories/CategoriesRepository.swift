import Foundation

protocol CategoriesRepositoryProtocol {
    func fetchCategories() async throws -> [CategoryItem]
}

final class CategoriesRepository: CategoriesRepositoryProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchCategories() async throws -> [CategoryItem] {
        try await apiClient.send(.categories)
    }
}
