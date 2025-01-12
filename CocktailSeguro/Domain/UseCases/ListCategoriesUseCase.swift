// ListCategoriesUseCase.swift
import Foundation

struct ListCategoriesUseCase {
    private let repository: CocktailsRepositoryProtocol
    
    init(repository: CocktailsRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [String] {
        return try await repository.listCategories()
    }
}
