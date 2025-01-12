import Foundation

enum CocktailsError: Error, LocalizedError {
    case badURL
    case badServerResponse(statusCode: Int)
    case decodingError
    case noData
    case custom(message: String)
    
    var errorDescription: String? {
        switch self {
        case .badURL:
            return "The URL is invalid or malformed."
        case .badServerResponse(let statusCode):
            return "Server responded with an error. Status code: \(statusCode)."
        case .decodingError:
            return "Failed to decode the data from the server."
        case .noData:
            return "The server returned no data."
        case .custom(let message):
            return message
        }
    }
}
