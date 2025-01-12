import Foundation
import Combine

final class RootViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var cocktails: [Cocktail] = []
    @Published var categories: [String] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Use Cases
    private let searchCocktailsUseCase: SearchCocktailsUseCase
    private let listCocktailsByFirstLetterUseCase: ListCocktailsByFirstLetterUseCase
    private let getCocktailDetailsUseCase: GetCocktailDetailsUseCase
    private let listCocktailsByIngredientUseCase: ListCocktailsByIngredientUseCase
    private let listCategoriesUseCase: ListCategoriesUseCase
    
    // MARK: - Init
    init(repository: CocktailsRepositoryProtocol) {
        self.searchCocktailsUseCase = SearchCocktailsUseCase(repository: repository)
        self.listCocktailsByFirstLetterUseCase = ListCocktailsByFirstLetterUseCase(repository: repository)
        self.getCocktailDetailsUseCase = GetCocktailDetailsUseCase(repository: repository)
        self.listCocktailsByIngredientUseCase = ListCocktailsByIngredientUseCase(repository: repository)
        self.listCategoriesUseCase = ListCategoriesUseCase(repository: repository)
    }
    
    // MARK: - Functions
    
    func loadCategories() async {
        isLoading = true
        do {
            let categories = try await listCategoriesUseCase.execute()
            DispatchQueue.main.async {
                self.categories = categories
                self.isLoading = false
            }
        } catch {
            handleError(error)
        }
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
            handleError(error)
        }
    }
    
    private func handleError(_ error: Error) {
        DispatchQueue.main.async {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
}
