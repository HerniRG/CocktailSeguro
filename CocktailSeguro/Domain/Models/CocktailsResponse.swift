struct CocktailsResponse: Decodable {
    let drinks: [Cocktail]
}

struct CategoriesResponse: Decodable {
    let drinks: [Category]
}

struct Cocktail: Decodable {
    let idDrink: String
    let strDrink: String
    let strCategory: String?
    let strAlcoholic: String?
    let strGlass: String?
    let strInstructions: String?
    let strDrinkThumb: String?
}

struct Category: Decodable {
    let strCategory: String
}
