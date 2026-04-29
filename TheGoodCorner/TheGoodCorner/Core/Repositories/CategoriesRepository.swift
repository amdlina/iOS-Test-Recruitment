import Foundation

protocol CategoriesRepositoryProtocol {
    func fetchCategories() async throws -> [Category]
}

final class CategoriesRepository: CategoriesRepositoryProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchCategories() async throws -> [Category] {
        try await apiClient.send(.categories)
    }
}
