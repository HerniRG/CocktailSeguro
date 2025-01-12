import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel
    @State private var searchQuery: String = ""
    
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
                noResultsView(message: "No results found for your search.")
                Spacer()
            } else {
                cocktailsList
            }
        }
        .navigationTitle("Search")
    }
    
    private var searchBar: some View {
        HStack {
            TextField("Search Cocktails...", text: $searchQuery)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button(action: {
                Task {
                    await viewModel.searchCocktails(name: searchQuery)
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
