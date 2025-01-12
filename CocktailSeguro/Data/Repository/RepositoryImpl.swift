import Foundation

final class CocktailsRepositoryImpl: CocktailsRepositoryProtocol {
    
    // MARK: - Properties
    private var remoteDataSource: CocktailsRemoteDataSourceProtocol
    
    // MARK: - Init
    init(remoteDataSource: CocktailsRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    // MARK: - Functions
    
    /// Busca cocktails por nombre
    func searchCocktails(byName name: String) async throws -> [Cocktail] {
        return try await remoteDataSource.searchCocktails(byName: name)
    }
    
    /// Lista todos los cocktails por la primera letra
    func listCocktails(byFirstLetter letter: String) async throws -> [Cocktail] {
        return try await remoteDataSource.listCocktails(byFirstLetter: letter)
    }
    
    /// Busca detalles completos de un cocktail por ID
    func getCocktailDetails(byId id: String) async throws -> Cocktail? {
        return try await remoteDataSource.getCocktailDetails(byId: id)
    }
    
    /// Lista cocktails por ingrediente
    func listCocktails(byIngredient ingredient: String) async throws -> [Cocktail] {
        return try await remoteDataSource.listCocktails(byIngredient: ingredient)
    }
    
    /// Lista categorías disponibles
    func listCategories() async throws -> [String] {
        return try await remoteDataSource.listCategories()
    }
}
