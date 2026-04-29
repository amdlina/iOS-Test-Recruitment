import Foundation

protocol ListingsRepositoryProtocol {
    func fetchListings(page: Int?, limit: Int?, query: String?) async throws -> ListingsResponse
}

final class ListingsRepository: ListingsRepositoryProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchListings(page: Int? = nil, limit: Int? = nil, query: String? = nil) async throws -> ListingsResponse {
        try await apiClient.send(.listings(page: page, limit: limit, query: query))
    }
}
