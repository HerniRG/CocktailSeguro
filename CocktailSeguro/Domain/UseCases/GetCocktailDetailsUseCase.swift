// GetCocktailDetailsUseCase.swift
import Foundation

struct GetCocktailDetailsUseCase {
    private let repository: CocktailsRepositoryProtocol
    
    init(repository: CocktailsRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(id: String) async throws -> Cocktail? {
        return try await repository.getCocktailDetails(byId: id)
    }
}
