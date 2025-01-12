import Foundation

final class RootViewModel {
    
    // MARK: - ViewModels
    let categoriesViewModel: CategoriesViewModel
    let searchViewModel: SearchViewModel
    let ingredientsViewModel: IngredientsViewModel
    
    // MARK: - Init
    init(repository: CocktailsRepositoryProtocol) {
        let listCategoriesUseCase = ListCategoriesUseCase(repository: repository)
        let searchCocktailsUseCase = SearchCocktailsUseCase(repository: repository)
        let listCocktailsByIngredientUseCase = ListCocktailsByIngredientUseCase(repository: repository)
        
        // Inicializar los ViewModels de las pestañas
        self.categoriesViewModel = CategoriesViewModel(listCategoriesUseCase: listCategoriesUseCase)
        self.searchViewModel = SearchViewModel(searchCocktailsUseCase: searchCocktailsUseCase)
        self.ingredientsViewModel = IngredientsViewModel(listCocktailsByIngredientUseCase: listCocktailsByIngredientUseCase)
    }
}
