import SwiftUI

struct IngredientsView: View {
    @StateObject var viewModel: IngredientsViewModel
    @State private var ingredient: String = ""
    
    var body: some View {
        VStack {
            TextField("Enter an ingredient...", text: $ingredient)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Search by Ingredient") {
                Task {
                    await viewModel.searchByIngredient(ingredient: ingredient)
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
