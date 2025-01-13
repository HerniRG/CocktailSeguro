import SwiftUI

struct CategoriesView: View {
    @StateObject var viewModel: CategoriesViewModel

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            if viewModel.isLoading {
                LoadingView(message: "Loading categories...")
            } else if let errorMessage = viewModel.errorMessage {
                ErrorView(message: errorMessage)
            } else if viewModel.categories.isEmpty {
                NoResultsView(message: "No categories available at the moment.")
            } else {
                categoriesList
            }
            Spacer()
        }
        .navigationTitle("Categories")
        .onAppear {
            Task {
                await viewModel.loadCategories()
            }
        }
    }

    private var categoriesList: some View {
        List(viewModel.categories, id: \.self) { category in
            HStack {
                Image(systemName: "tag.fill")
                    .foregroundColor(.blue)
                Text(category)
                    .font(.headline)
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}
