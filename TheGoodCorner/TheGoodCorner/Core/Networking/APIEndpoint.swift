import Foundation

enum APIEndpoint: Equatable {
    case listings(page: Int? = nil, limit: Int? = nil, query: String? = nil)
    case categories

    private var path: String {
        switch self {
        case .listings:
            return "/listings"
        case .categories:
            return "/categories"
        }
    }

    private var queryItems: [URLQueryItem] {
        switch self {
        case .categories:
            return []
        case .listings(let page, let limit, let query):
            var items: [URLQueryItem] = []

            if let page {
                items.append(URLQueryItem(name: "page", value: String(page)))
            }

            if let limit {
                items.append(URLQueryItem(name: "limit", value: String(limit)))
            }

            if let query, !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                items.append(URLQueryItem(name: "query", value: query))
            }

            return items
        }
    }

    func urlRequest(baseURL: URL) throws -> URLRequest {
        guard var components = URLComponents(
            url: baseURL.appendingPathComponent(path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))),
            resolvingAgainstBaseURL: false
        ) else {
            throw APIError.invalidURL
        }

        components.queryItems = queryItems.isEmpty ? nil : queryItems

        guard let url = components.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 20
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
