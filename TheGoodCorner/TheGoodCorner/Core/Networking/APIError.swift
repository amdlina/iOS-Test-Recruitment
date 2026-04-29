import Foundation

enum APIError: LocalizedError, Equatable {
    case invalidURL
    case invalidResponse
    case httpStatus(Int)
    case decoding
    case transport(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL is invalid."
        case .invalidResponse:
            return "The server response is invalid."
        case .httpStatus:
            return "The server returned an error."
        case .decoding:
            return "The server response could not be read."
        case .transport:
            return "The network request failed."
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .invalidURL:
            return "Check the API configuration."
        case .invalidResponse, .httpStatus, .decoding:
            return "Please try again."
        case .transport:
            return "Check that the local server is running on http://localhost:8080."
        }
    }
}
