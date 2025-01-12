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
        isLoading = true
        do {
            let results = try await searchCocktailsUseCase.execute(name: name)
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
