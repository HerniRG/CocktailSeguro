protocol CocktailsRepositoryProtocol {
    func searchCocktails(byName name: String) async throws -> [Cocktail]
    func listCocktails(byFirstLetter letter: String) async throws -> [Cocktail]
    func getCocktailDetails(byId id: String) async throws -> Cocktail?
    func listCocktails(byIngredient ingredient: String) async throws -> [Cocktail]
    func listCategories() async throws -> [String]
}
