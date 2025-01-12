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
        }
        
        do {
            let categories = try await listCategoriesUseCase.execute()
            DispatchQueue.main.async {
                self.categories = categories
                self.isLoading = false
                self.errorMessage = nil // Limpia cualquier error previo
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}
