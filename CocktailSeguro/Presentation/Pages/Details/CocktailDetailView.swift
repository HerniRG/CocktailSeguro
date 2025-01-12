import SwiftUI

struct CocktailDetailView: View {
    @StateObject var viewModel: CocktailDetailViewModel
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .padding()
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else if let cocktail = viewModel.cocktail {
                ScrollView {
                    // Mostrar los detalles del cóctel
                }
            } else {
                Text("No cocktail details available.")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .navigationTitle("Cocktail Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await viewModel.loadCocktailDetails(id: viewModel.cocktail?.idDrink ?? "")
            }
        }
    }
}
