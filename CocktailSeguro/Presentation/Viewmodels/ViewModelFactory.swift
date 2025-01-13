struct ViewModelFactory {
    let repository: CocktailsRepositoryProtocol

    func makeCategoriesViewModel() -> CategoriesViewModel {
        CategoriesViewModel(listCategoriesUseCase: ListCategoriesUseCase(repository: repository))
    }

    func makeSearchViewModel() -> SearchViewModel {
        SearchViewModel(searchCocktailsUseCase: SearchCocktailsUseCase(repository: repository))
    }

    func makeIngredientsViewModel() -> IngredientsViewModel {
        IngredientsViewModel(listCocktailsByIngredientUseCase: ListCocktailsByIngredientUseCase(repository: repository))
    }
}
