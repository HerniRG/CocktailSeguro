import Foundation

final class CocktailsURLRequestHelperImpl: URLRequestHelperProtocol {
    
    // MARK: - Properties
    private let baseURL = "https://www.thecocktaildb.com/api/json/v1/1/"
    
    // MARK: - Endpoints
    private enum Endpoint: String {
        case search = "search.php"
        case lookup = "lookup.php"
        case filter = "filter.php"
        case list = "list.php"
    }
    
    // MARK: - Functions
    
    func searchCocktails(byName name: String) -> URLRequest? {
        createURLRequest(for: .search, queryItems: ["s": name])
    }
    
    func listCocktails(byIngredient ingredient: String) -> URLRequest? {
        createURLRequest(for: .filter, queryItems: ["i": ingredient])
    }
    
    func listCategories() -> URLRequest? {
        createURLRequest(for: .list, queryItems: ["c": "list"])
    }
    
    // MARK: - Private Helper
    
    private func createURLRequest(for endpoint: Endpoint, queryItems: [String: String]) -> URLRequest? {
        var components = URLComponents(string: "\(baseURL)\(endpoint.rawValue)")
        components?.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = components?.url else {
            print("Error creating URL for endpoint: \(endpoint.rawValue) with queryItems: \(queryItems)")
            return nil
        }
        return URLRequest(url: url)
    }
}
