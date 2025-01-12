import SwiftUI

struct RootView: View {
    let rootViewModel: RootViewModel
    
    var body: some View {
        NavigationView {
            TabView {
                // Tab 1: Categorías
                CategoriesView(viewModel: rootViewModel.categoriesViewModel)
                    .tabItem {
                        Label("Categories", systemImage: "list.bullet")
                    }
                
                // Tab 2: Búsqueda
                SearchView(viewModel: rootViewModel.searchViewModel)
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                
                // Tab 3: Ingredientes
                IngredientsView(viewModel: rootViewModel.ingredientsViewModel)
                    .tabItem {
                        Label("Ingredients", systemImage: "leaf")
                    }
            }
            .background(Color(.systemBackground))
        }
    }
}
