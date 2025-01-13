import SwiftUI

struct IngredientsView: View {
    @StateObject var viewModel: IngredientsViewModel
    @State private var ingredient: String = ""

    var body: some View {
        VStack(spacing: 0) {
            SearchBar(query: $ingredient, placeholder: "Enter an ingredient...") {
                Task {
                    await viewModel.searchByIngredient(ingredient: ingredient)
                }
            }
            Spacer()
            if viewModel.isLoading {
                LoadingView(message: "Searching...")
            } else if let errorMessage = viewModel.errorMessage {
                ErrorView(message: errorMessage)
            } else if viewModel.cocktails.isEmpty {
                NoResultsView(message: "No cocktails found for the entered ingredient.")
            } else {
                cocktailsList
            }
            Spacer() 
        }
        .navigationTitle("Ingredients")
    }

    private var cocktailsList: some View {
        List(viewModel.cocktails, id: \.idDrink) { cocktail in
            CocktailRowView(cocktail: cocktail)
        }
        .listStyle(InsetGroupedListStyle())
    }
}
