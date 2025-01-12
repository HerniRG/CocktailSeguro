import SwiftUI

struct CategoriesView: View {
    @StateObject var viewModel: CategoriesViewModel
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading categories...")
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)").foregroundColor(.red)
            } else {
                List(viewModel.categories, id: \.self) { category in
                    Text(category)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.loadCategories()
            }
        }
    }
}
