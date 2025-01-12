import Foundation

protocol CocktailsRemoteDataSourceProtocol {
    func searchCocktails(byName name: String) async throws -> [Cocktail]
    func listCocktails(byFirstLetter letter: String) async throws -> [Cocktail]
    func getCocktailDetails(byId id: String) async throws -> Cocktail?
    func listCocktails(byIngredient ingredient: String) async throws -> [Cocktail]
    func listCategories() async throws -> [String]
}

final class CocktailsRemoteDataSourceImpl: CocktailsRemoteDataSourceProtocol {
    
    // MARK: - Properties
    var urlRequestHelper: URLRequestHelperProtocol = CocktailsURLRequestHelperImpl()
    
    // MARK: - Functions
    
    func searchCocktails(byName name: String) async throws -> [Cocktail] {
        guard let urlRequest = urlRequestHelper.searchCocktails(byName: name) else {
            print("Error creating URLRequest for searchCocktails")
            throw URLError(.badURL)
        }
        return try await fetchCocktails(with: urlRequest)
    }
    
    func listCocktails(byFirstLetter letter: String) async throws -> [Cocktail] {
        guard let urlRequest = urlRequestHelper.listCocktails(byFirstLetter: letter) else {
            print("Error creating URLRequest for listCocktails")
            throw URLError(.badURL)
        }
        return try await fetchCocktails(with: urlRequest)
    }
    
    func getCocktailDetails(byId id: String) async throws -> Cocktail? {
        guard let urlRequest = urlRequestHelper.getCocktailDetails(byId: id) else {
            print("Error creating URLRequest for getCocktailDetails")
            throw URLError(.badURL)
        }
        let cocktails = try await fetchCocktails(with: urlRequest)
        return cocktails.first
    }
    
    func listCocktails(byIngredient ingredient: String) async throws -> [Cocktail] {
        guard let urlRequest = urlRequestHelper.listCocktails(byIngredient: ingredient) else {
            print("Error creating URLRequest for listCocktails by ingredient")
            throw URLError(.badURL)
        }
        return try await fetchCocktails(with: urlRequest)
    }
    
    func listCategories() async throws -> [String] {
        guard let urlRequest = urlRequestHelper.listCategories() else {
            print("Error creating URLRequest for listCategories")
            throw URLError(.badURL)
        }
        
        let (data, httpResponse) = try await URLSession.shared.data(for: urlRequest)
        guard let response = httpResponse as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard response.statusCode == 200 else {
            print("Error: Server responded with status code \(response.statusCode)")
            throw URLError(.badServerResponse)
        }
        
        let decodedResponse = try JSONDecoder().decode(CategoriesResponse.self, from: data)
        return decodedResponse.drinks.map { $0.strCategory }
    }
    
    // MARK: - Helper Functions
    
    private func fetchCocktails(with urlRequest: URLRequest) async throws -> [Cocktail] {
        let (data, httpResponse) = try await URLSession.shared.data(for: urlRequest)
        guard let response = httpResponse as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard response.statusCode == 200 else {
            print("Error: Server responded with status code \(response.statusCode)")
            throw URLError(.badServerResponse)
        }
        
        let decodedResponse = try JSONDecoder().decode(CocktailsResponse.self, from: data)
        return decodedResponse.drinks
    }
}
