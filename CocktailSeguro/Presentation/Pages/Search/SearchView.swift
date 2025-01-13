import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel
    @State private var searchQuery: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBar(query: $searchQuery, placeholder: "Search Cocktails...") {
                Task {
                    await viewModel.searchCocktails(name: searchQuery)
                }
            }
            Spacer()
            if viewModel.isLoading {
                LoadingView(message: "Searching...")
            } else if let errorMessage = viewModel.errorMessage {
                ErrorView(message: errorMessage)
            } else if viewModel.cocktails.isEmpty {
                NoResultsView(message: "No results found for your search.")
            } else {
                cocktailsList
            }
            Spacer()
        }
        .navigationTitle("Search")
    }
    
    private var cocktailsList: some View {
        List(viewModel.cocktails, id: \.idDrink) { cocktail in
            CocktailRowView(cocktail: cocktail)
        }
        .listStyle(InsetGroupedListStyle())
    }
}
