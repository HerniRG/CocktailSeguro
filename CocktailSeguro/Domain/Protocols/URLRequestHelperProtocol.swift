import Foundation

protocol URLRequestHelperProtocol {
    func searchCocktails(byName name: String) -> URLRequest?
    func listCocktails(byIngredient ingredient: String) -> URLRequest?
    func listCategories() -> URLRequest?
}
