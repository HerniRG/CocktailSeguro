import Foundation
import Combine

final class IngredientsViewModel: ObservableObject {
    @Published var cocktails: [Cocktail] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let listCocktailsByIngredientUseCase: ListCocktailsByIngredientUseCase

    init(listCocktailsByIngredientUseCase: ListCocktailsByIngredientUseCase) {
        self.listCocktailsByIngredientUseCase = listCocktailsByIngredientUseCase
    }

    func searchByIngredient(ingredient: String) async {
        updateState(isLoading: true)

        do {
            let results = try await listCocktailsByIngredientUseCase.execute(ingredient: ingredient)
            handleSuccess(results: results, ingredient: ingredient)
        } catch let error as CocktailsError {
            handleError(message: error.localizedDescription)
        } catch {
            handleError(message: "An unexpected error occurred. Please try again.")
        }
    }

    // MARK: - Private Helpers

    private func updateState(cocktails: [Cocktail] = [], isLoading: Bool = false, errorMessage: String? = nil) {
        DispatchQueue.main.async {
            self.cocktails = cocktails
            self.isLoading = isLoading
            self.errorMessage = errorMessage
        }
    }

    private func handleSuccess(results: [Cocktail], ingredient: String) {
        if results.isEmpty {
            handleError(message: "No cocktails found for ingredient: \(ingredient).")
        } else {
            updateState(cocktails: results)
        }
    }

    private func handleError(message: String) {
        updateState(errorMessage: message)
    }
}
