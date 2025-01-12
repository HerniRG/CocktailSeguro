import SwiftUI

@main
struct CocktailSeguroApp: App {
    var body: some Scene {
        WindowGroup {
            let remoteDataSource = CocktailsRemoteDataSourceImpl()
            let repository = CocktailsRepositoryImpl(remoteDataSource: remoteDataSource)
            let rootViewModel = RootViewModel(repository: repository)
            
            RootView(rootViewModel: rootViewModel)
        }
    }
}
