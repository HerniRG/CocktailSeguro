import SwiftUI

struct CategoriesView: View {
    @StateObject var viewModel: CategoriesViewModel
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading categories...")
                    .padding()
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(viewModel.categories, id: \.self) { category in
                            HStack {
                                Image(systemName: "tag")
                                    .foregroundColor(.blue)
                                Text(category)
                                    .font(.headline)
                            }
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray6))
                            )
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Categories")
        .background(Color(.systemBackground))
        .onAppear {
            Task {
                await viewModel.loadCategories()
            }
        }
    }
}
