import Foundation

protocol URLRequestHelperProtocol {
    func searchCocktails(byName name: String) -> URLRequest?
    func listCocktails(byFirstLetter letter: String) -> URLRequest?
    func getCocktailDetails(byId id: String) -> URLRequest?
    func listCocktails(byIngredient ingredient: String) -> URLRequest?
    func listCategories() -> URLRequest?
}
