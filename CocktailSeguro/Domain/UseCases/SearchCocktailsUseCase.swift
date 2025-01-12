// SearchCocktailsUseCase.swift
import Foundation

struct SearchCocktailsUseCase {
    private let repository: CocktailsRepositoryProtocol
    
    init(repository: CocktailsRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(name: String) async throws -> [Cocktail] {
        return try await repository.searchCocktails(byName: name)
    }
}
