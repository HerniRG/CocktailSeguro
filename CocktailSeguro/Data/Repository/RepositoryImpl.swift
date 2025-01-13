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
    
    /// Lista cocktails por ingrediente
    func listCocktails(byIngredient ingredient: String) async throws -> [Cocktail] {
        return try await remoteDataSource.listCocktails(byIngredient: ingredient)
    }
    
    /// Lista categorías disponibles
    func listCategories() async throws -> [String] {
        return try await remoteDataSource.listCategories()
    }
}
