import Foundation

final class CocktailsURLRequestHelperImpl: URLRequestHelperProtocol {
    
    // MARK: - Properties
    private let baseURL = "https://www.thecocktaildb.com/api/json/v1/1/"
    
    // MARK: - Endpoints
    private struct Endpoints {
        static let search = "search.php"
        static let lookup = "lookup.php"
        static let filter = "filter.php"
        static let list = "list.php"
    }
    
    // MARK: - Functions
    
    func searchCocktails(byName name: String) -> URLRequest? {
        guard let url = URL(string: "\(baseURL)\(Endpoints.search)?s=\(name)") else {
            print("Error creating URL for searchCocktails")
            return nil
        }
        return URLRequest(url: url)
    }
    
    func listCocktails(byFirstLetter letter: String) -> URLRequest? {
        guard let url = URL(string: "\(baseURL)\(Endpoints.search)?f=\(letter)") else {
            print("Error creating URL for listCocktails")
            return nil
        }
        return URLRequest(url: url)
    }
    
    func getCocktailDetails(byId id: String) -> URLRequest? {
        guard let url = URL(string: "\(baseURL)\(Endpoints.lookup)?i=\(id)") else {
            print("Error creating URL for getCocktailDetails")
            return nil
        }
        return URLRequest(url: url)
    }
    
    func listCocktails(byIngredient ingredient: String) -> URLRequest? {
        guard let url = URL(string: "\(baseURL)\(Endpoints.filter)?i=\(ingredient)") else {
            print("Error creating URL for listCocktails by ingredient")
            return nil
        }
        return URLRequest(url: url)
    }
    
    func listCategories() -> URLRequest? {
        guard let url = URL(string: "\(baseURL)\(Endpoints.list)?c=list") else {
            print("Error creating URL for listCategories")
            return nil
        }
        return URLRequest(url: url)
    }
}
