// ListCocktailsByIngredientUseCase.swift
import Foundation

struct ListCocktailsByIngredientUseCase {
    private let repository: CocktailsRepositoryProtocol
    
    init(repository: CocktailsRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(ingredient: String) async throws -> [Cocktail] {
        return try await repository.listCocktails(byIngredient: ingredient)
    }
}
