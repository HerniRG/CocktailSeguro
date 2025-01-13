import Foundation

struct CocktailEndpoints {
    static let baseURL = "https://www.thecocktaildb.com/api/json/v1/1/"
    
    enum Endpoint: String {
        case search = "search.php"
        case lookup = "lookup.php"
        case filter = "filter.php"
        case list = "list.php"
    }
}
