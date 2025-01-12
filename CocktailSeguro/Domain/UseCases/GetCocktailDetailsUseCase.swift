// GetCocktailDetailsUseCase.swift
import Foundation

struct GetCocktailDetailsUseCase {
    private let repository: CocktailsRepositoryProtocol
    
    init(repository: CocktailsRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(id: String) async throws -> Cocktail {
        guard let cocktail = try await repository.getCocktailDetails(byId: id) else {
            throw CocktailsError.custom(message: "No details found for the requested cocktail.")
        }
        return cocktail
    }
}
