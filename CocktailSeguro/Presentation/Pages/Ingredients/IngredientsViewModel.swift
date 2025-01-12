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
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        do {
            let results = try await listCocktailsByIngredientUseCase.execute(ingredient: ingredient)
            DispatchQueue.main.async {
                if results.isEmpty {
                    self.errorMessage = "No cocktails found for ingredient: \(ingredient)."
                } else {
                    self.cocktails = results
                }
                self.isLoading = false
            }
        } catch let error as CocktailsError {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "An unexpected error occurred. Please try again."
                self.isLoading = false
            }
        }
    }
}
