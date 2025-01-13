import SwiftUI

@main
struct CocktailSeguroApp: App {
    
    var body: some Scene {
        WindowGroup {
            let remoteDataSource = CocktailsRemoteDataSourceImpl()
            let repository = CocktailsRepositoryImpl(remoteDataSource: remoteDataSource)
            let factory = ViewModelFactory(repository: repository)
            let rootViewModel = RootViewModel(factory: factory)
            
            RootView(rootViewModel: rootViewModel)
        }
    }
}
