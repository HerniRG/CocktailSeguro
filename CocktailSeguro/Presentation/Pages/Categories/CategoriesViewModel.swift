import Foundation
import Combine

final class CategoriesViewModel: ObservableObject {
    @Published var categories: [String] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let listCategoriesUseCase: ListCategoriesUseCase
    
    init(listCategoriesUseCase: ListCategoriesUseCase) {
        self.listCategoriesUseCase = listCategoriesUseCase
    }
    
    func loadCategories() async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        do {
            let categories = try await listCategoriesUseCase.execute()
            DispatchQueue.main.async {
                if categories.isEmpty {
                    self.errorMessage = "No categories available at the moment."
                } else {
                    self.categories = categories
                }
                self.isLoading = false
            }
        } catch let error as CocktailsError {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "An unexpected error occurred. Please try again."
                self.isLoading = false
            }
        }
    }
}
