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
        isLoading = true
        do {
            let results = try await listCocktailsByIngredientUseCase.execute(ingredient: ingredient)
            DispatchQueue.main.async {
                self.cocktails = results
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}
