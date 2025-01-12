import SwiftUI

@main
struct CocktailSeguroApp: App {
    init() {
        // Crear una instancia de UITabBarAppearance
        let appearance = UITabBarAppearance()
        
        // Configurar con fondo opaco
        appearance.configureWithOpaqueBackground()
        
        // Establecer el color de fondo deseado (puede ser systemBackground o cualquier otro color)
        appearance.backgroundColor = UIColor.systemBackground
        
        // Aplicar la apariencia configurada a UITabBar
        UITabBar.appearance().standardAppearance = appearance
        
        // Para iOS 15 y superiores, también establece scrollEdgeAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some Scene {
        WindowGroup {
            let remoteDataSource = CocktailsRemoteDataSourceImpl()
            let repository = CocktailsRepositoryImpl(remoteDataSource: remoteDataSource)
            let rootViewModel = RootViewModel(repository: repository)
            
            RootView(rootViewModel: rootViewModel)
        }
    }
}
