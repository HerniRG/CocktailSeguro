import Foundation
import Combine

final class SearchViewModel: ObservableObject {
    @Published var cocktails: [Cocktail] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let searchCocktailsUseCase: SearchCocktailsUseCase
    
    init(searchCocktailsUseCase: SearchCocktailsUseCase) {
        self.searchCocktailsUseCase = searchCocktailsUseCase
    }
    
    func searchCocktails(name: String) async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        do {
            let results = try await searchCocktailsUseCase.execute(name: name)
            DispatchQueue.main.async {
                if results.isEmpty {
                    self.errorMessage = "No cocktails found for name: \(name)."
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
                self.errorMessage = "An unexpected error occurred."
                self.isLoading = false
            }
        }
    }
}
