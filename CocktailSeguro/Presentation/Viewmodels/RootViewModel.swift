final class RootViewModel {
    let categoriesViewModel: CategoriesViewModel
    let searchViewModel: SearchViewModel
    let ingredientsViewModel: IngredientsViewModel

    init(factory: ViewModelFactory) {
        self.categoriesViewModel = factory.makeCategoriesViewModel()
        self.searchViewModel = factory.makeSearchViewModel()
        self.ingredientsViewModel = factory.makeIngredientsViewModel()
    }
}
