import SwiftUI

struct IngredientsView: View {
    @StateObject var viewModel: IngredientsViewModel
    @State private var ingredient: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            searchBar // Siempre en la parte superior
            
            if viewModel.isLoading {
                Spacer()
                ProgressView("Searching...")
                    .padding()
                Spacer()
            } else if let errorMessage = viewModel.errorMessage {
                Spacer()
                errorMessageView(message: errorMessage)
                Spacer()
            } else if viewModel.cocktails.isEmpty {
                Spacer()
                noResultsView(message: "No cocktails found for the entered ingredient.")
                Spacer()
            } else {
                cocktailsList
            }
        }
        .navigationTitle("Ingredients")
    }
    
    private var searchBar: some View {
        HStack {
            TextField("Enter an ingredient...", text: $ingredient)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button(action: {
                Task {
                    await viewModel.searchByIngredient(ingredient: ingredient)
                }
            }) {
                Image(systemName: "magnifyingglass")
                    .padding(10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Circle())
            }
        }
        .padding()
    }
    
    private func errorMessageView(message: String) -> some View {
        Text(message)
            .foregroundColor(.red)
            .multilineTextAlignment(.center)
            .padding()
    }
    
    private func noResultsView(message: String) -> some View {
        Text(message)
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
            .padding()
    }
    
    private var cocktailsList: some View {
        List(viewModel.cocktails, id: \.idDrink) { cocktail in
            CocktailRowView(cocktail: cocktail)
        }
        .listStyle(InsetGroupedListStyle())
    }
}
