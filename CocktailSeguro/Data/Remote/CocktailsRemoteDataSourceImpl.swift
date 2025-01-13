import Foundation

protocol CocktailsRemoteDataSourceProtocol {
    func searchCocktails(byName name: String) async throws -> [Cocktail]
    func listCocktails(byIngredient ingredient: String) async throws -> [Cocktail]
    func listCategories() async throws -> [String]
}

final class CocktailsRemoteDataSourceImpl: CocktailsRemoteDataSourceProtocol {
    
    // MARK: - Properties
    var urlRequestHelper: URLRequestHelperProtocol = CocktailsURLRequestHelperImpl()
    
    // MARK: - Functions
    
    func searchCocktails(byName name: String) async throws -> [Cocktail] {
        try await fetchCocktails(from: urlRequestHelper.searchCocktails(byName: name))
    }
    
    func listCocktails(byIngredient ingredient: String) async throws -> [Cocktail] {
        try await fetchCocktails(from: urlRequestHelper.listCocktails(byIngredient: ingredient))
    }
    
    func listCategories() async throws -> [String] {
        try await fetchData(from: urlRequestHelper.listCategories(), decodeAs: CategoriesResponse.self).drinks.map { $0.strCategory }
    }
    
    // MARK: - Private Helpers
    
    private func fetchCocktails(from urlRequest: URLRequest?) async throws -> [Cocktail] {
        let response: CocktailsResponse = try await fetchData(from: urlRequest, decodeAs: CocktailsResponse.self)
        return response.drinks ?? []
    }
    
    private func fetchData<T: Decodable>(from urlRequest: URLRequest?, decodeAs type: T.Type) async throws -> T {
        guard let urlRequest = urlRequest else {
            throw CocktailsError.badURL
        }
        
        let (data, httpResponse) = try await URLSession.shared.data(for: urlRequest)
        
        guard let response = httpResponse as? HTTPURLResponse else {
            throw CocktailsError.badServerResponse(statusCode: -1)
        }
        
        guard response.statusCode == 200 else {
            throw CocktailsError.badServerResponse(statusCode: response.statusCode)
        }
        
        guard !data.isEmpty else {
            throw CocktailsError.noData
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            return try decoder.decode(T.self, from: data)
        } catch {
            throw CocktailsError.decodingError
        }
    }
}
