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
            throw CocktailsError.badURL
        }
        return try await fetchCocktails(with: urlRequest)
    }
    
    func listCocktails(byFirstLetter letter: String) async throws -> [Cocktail] {
        guard let urlRequest = urlRequestHelper.listCocktails(byFirstLetter: letter) else {
            throw CocktailsError.badURL
        }
        return try await fetchCocktails(with: urlRequest)
    }
    
    func getCocktailDetails(byId id: String)  async throws -> Cocktail? {
        guard let urlRequest = urlRequestHelper.getCocktailDetails(byId: id) else {
            throw CocktailsError.badURL
        }
        return try await fetchCocktails(with: urlRequest).first
    }

    
    func listCocktails(byIngredient ingredient: String) async throws -> [Cocktail] {
        guard let urlRequest = urlRequestHelper.listCocktails(byIngredient: ingredient) else {
            throw CocktailsError.badURL
        }
        return try await fetchCocktails(with: urlRequest)
    }
    
    func listCategories() async throws -> [String] {
        guard let urlRequest = urlRequestHelper.listCategories() else {
            throw CocktailsError.badURL
        }
        
        let (data, httpResponse) = try await URLSession.shared.data(for: urlRequest)
        guard let response = httpResponse as? HTTPURLResponse else {
            throw CocktailsError.badServerResponse(statusCode: -1)
        }
        
        guard response.statusCode == 200 else {
            throw CocktailsError.badServerResponse(statusCode: response.statusCode)
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(CategoriesResponse.self, from: data)
            return decodedResponse.drinks.map { $0.strCategory }
        } catch {
            throw CocktailsError.decodingError
        }
    }
    
    // MARK: - Helper Functions
    
    private func fetchCocktails(with urlRequest: URLRequest) async throws -> [Cocktail] {
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
            decoder.keyDecodingStrategy = .useDefaultKeys // or customize if needed
            let decodedResponse = try decoder.decode(CocktailsResponse.self, from: data)
            return decodedResponse.drinks ?? []
        } catch let decodingError as DecodingError {
            // Detailed decoding error logging
            switch decodingError {
            case .typeMismatch(let type, let context):
                print("Type Mismatch for type \(type) in context: \(context)")
            case .valueNotFound(let type, let context):
                print("Value not found for type \(type) in context: \(context)")
            case .keyNotFound(let key, let context):
                print("Key '\(key)' not found in context: \(context.debugDescription)")
                print("CodingPath:", context.codingPath)
            case .dataCorrupted(let context):
                print("Data corrupted in context: \(context)")
            @unknown default:
                print("Unknown decoding error: \(decodingError)")
            }
            throw CocktailsError.decodingError
        } catch {
            print("Unexpected error during decoding: \(error)")
            throw CocktailsError.decodingError
        }
    }
}
