import Foundation

struct AppEnvironment {
    let listingsRepository: ListingsRepositoryProtocol
    let categoriesRepository: CategoriesRepositoryProtocol

    static let live = AppEnvironment(
        listingsRepository: ListingsRepository(apiClient: APIClient(baseURL: AppConfiguration.baseURL)),
        categoriesRepository: CategoriesRepository(apiClient: APIClient(baseURL: AppConfiguration.baseURL))
    )
}
