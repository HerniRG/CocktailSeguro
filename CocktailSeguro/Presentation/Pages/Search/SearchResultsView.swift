import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel
    @State private var searchQuery: String = ""
    
    var body: some View {
        VStack {
            TextField("Search Cocktails...", text: $searchQuery)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Search") {
                Task {
                    await viewModel.searchCocktails(name: searchQuery)
                }
            }
            
            if viewModel.isLoading {
                ProgressView("Searching...")
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)").foregroundColor(.red)
            } else {
                List(viewModel.cocktails, id: \.idDrink) { cocktail in
                    Text(cocktail.strDrink)
                }
            }
        }
    }
}
