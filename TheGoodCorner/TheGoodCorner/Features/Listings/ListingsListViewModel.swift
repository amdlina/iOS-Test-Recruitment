import Foundation
import Combine

@MainActor
final class ListingsListViewModel: ObservableObject {
    enum ViewState: Equatable {
        case idle
        case loading
        case loaded([ListingDisplayItem])
        case empty(message: String)
        case error(message: String)
    }

    @Published private(set) var state: ViewState = .idle
    @Published private(set) var categories: [CategoryItem] = []
    @Published var selectedCategoryId: Int? = nil {
        didSet { applyFilters() }
    }

    private let listingsRepository: ListingsRepositoryProtocol
    private let categoriesRepository: CategoriesRepositoryProtocol
    private let priceFormatter: PriceFormatting
    private let baseURL: URL

    private var allListings: [Listing] = []
    private var categoriesById: [Int: CategoryItem] = [:]

    init(
        listingsRepository: ListingsRepositoryProtocol,
        categoriesRepository: CategoriesRepositoryProtocol,
        priceFormatter: PriceFormatting = PriceFormatter(),
        baseURL: URL = AppConfiguration.baseURL
    ) {
        self.listingsRepository = listingsRepository
        self.categoriesRepository = categoriesRepository
        self.priceFormatter = priceFormatter
        self.baseURL = baseURL
    }

    func load() async {
        state = .loading

        do {
            async let listingsResponse = listingsRepository.fetchListings(page: nil, limit: nil, query: nil)
            async let fetchedCategories = categoriesRepository.fetchCategories()

            let response = try await listingsResponse
            let categories = try await fetchedCategories

            self.allListings = response.items
            self.categories = categories
            self.categoriesById = Dictionary(uniqueKeysWithValues: categories.map { ($0.id, $0) })

            applyFilters()
        } catch {
            state = .error(message: userFriendlyMessage(for: error))
        }
    }

    func retry() async {
        await load()
    }

    func categoryName(for categoryId: Int) -> String {
        categoriesById[categoryId]?.name ?? "Catégorie inconnue"
    }

    private func applyFilters() {
        guard !allListings.isEmpty else {
            state = .empty(message: "Aucune annonce disponible pour le moment.")
            return
        }

        let filteredListings = allListings.filter { listing in
            guard let selectedCategoryId else { return true }
            return listing.categoryId == selectedCategoryId
        }

        let items = filteredListings.map(makeDisplayItem)

        if items.isEmpty {
            state = .empty(message: "Aucune annonce ne correspond à cette catégorie.")
        } else {
            state = .loaded(items)
        }
    }

    private func makeDisplayItem(from listing: Listing) -> ListingDisplayItem {
        ListingDisplayItem(
            listing: listing,
            categoryName: categoryName(for: listing.categoryId),
            formattedPrice: priceFormatter.format(price: listing.price),
            imageURL: makeImageURL(from: listing.imagesUrl?.small ?? listing.imagesUrl?.thumb)
        )
    }

    private func makeImageURL(from path: String?) -> URL? {
        guard let path, !path.isEmpty else { return nil }

        if let absoluteURL = URL(string: path), absoluteURL.scheme != nil {
            return absoluteURL
        }

        return baseURL.appendingPathComponent(path.trimmingCharacters(in: CharacterSet(charactersIn: "/")))
    }

    private func userFriendlyMessage(for error: Error) -> String {
        if let apiError = error as? APIError, let suggestion = apiError.recoverySuggestion {
            return suggestion
        }

        return "Impossible de charger les annonces. Vérifie que le serveur local est lancé puis réessaie."
    }
}
