import Foundation
import Combine

final class CategoriesViewModel: ObservableObject {
    @Published var categories: [String] = []
    @Published var isLoading: Bool = true
    @Published var errorMessage: String?

    private let listCategoriesUseCase: ListCategoriesUseCase

    init(listCategoriesUseCase: ListCategoriesUseCase) {
        self.listCategoriesUseCase = listCategoriesUseCase
    }

    func loadCategories() async {
        updateState(isLoading: true)

        do {
            let categories = try await listCategoriesUseCase.execute()
            handleSuccess(categories: categories)
        } catch let error as CocktailsError {
            handleError(message: error.localizedDescription)
        } catch {
            handleError(message: "An unexpected error occurred. Please try again.")
        }
    }

    // MARK: - Private Helpers

    private func updateState(categories: [String] = [], isLoading: Bool = false, errorMessage: String? = nil) {
        DispatchQueue.main.async {
            self.categories = categories
            self.isLoading = isLoading
            self.errorMessage = errorMessage
        }
    }

    private func handleSuccess(categories: [String]) {
        if categories.isEmpty {
            handleError(message: "No categories available at the moment.")
        } else {
            updateState(categories: categories)
        }
    }

    private func handleError(message: String) {
        updateState(errorMessage: message)
    }
}
