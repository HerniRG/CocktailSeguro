// ListCocktailsByFirstLetterUseCase.swift
import Foundation

struct ListCocktailsByFirstLetterUseCase {
    private let repository: CocktailsRepositoryProtocol
    
    init(repository: CocktailsRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(letter: String) async throws -> [Cocktail] {
        return try await repository.listCocktails(byFirstLetter: letter)
    }
}
