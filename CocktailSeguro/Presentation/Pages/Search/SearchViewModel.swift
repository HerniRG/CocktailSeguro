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
        updateState(isLoading: true)

        do {
            let results = try await searchCocktailsUseCase.execute(name: name)
            handleSuccess(results: results, name: name)
        } catch let error as CocktailsError {
            handleError(message: error.localizedDescription)
        } catch {
            handleError(message: "An unexpected error occurred.")
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

    private func handleSuccess(results: [Cocktail], name: String) {
        if results.isEmpty {
            handleError(message: "No cocktails found for name: \(name).")
        } else {
            updateState(cocktails: results)
        }
    }

    private func handleError(message: String) {
        updateState(errorMessage: message)
    }
}
