import Foundation
import Combine

final class CocktailDetailViewModel: ObservableObject {
    @Published var cocktail: Cocktail?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let getCocktailDetailsUseCase: GetCocktailDetailsUseCase
    
    init(getCocktailDetailsUseCase: GetCocktailDetailsUseCase) {
        self.getCocktailDetailsUseCase = getCocktailDetailsUseCase
    }
    
    func loadCocktailDetails(id: String) async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        do {
            let cocktail = try await getCocktailDetailsUseCase.execute(id: id)
            DispatchQueue.main.async {
                self.cocktail = cocktail
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
