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
            return "Une erreur de configuration est survenue."
        case .invalidResponse:
            return "La réponse du serveur est incorrecte."
        case .httpStatus:
            return "Le serveur a retourné une erreur."
        case .decoding:
            return "La réponse du serveur n'a pas pu être interprétée."
        case .transport:
            return "Impossible de contacter le serveur."
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .invalidURL:
            return "Vérifiez la configuration de l'API."
        case .invalidResponse, .httpStatus, .decoding:
            return "Veuillez réessayer."
        case .transport:
            return "Vérifiez que le serveur local fonctionne sur http://localhost:8080."
        }
    }
}
