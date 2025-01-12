//
//  CocktailSeguroApp.swift
//  CocktailSeguro
//
//  Created by Hernán Rodríguez on 12/1/25.
//

import SwiftUI

@main
struct CocktailSeguroApp: App {
    var body: some Scene {
        WindowGroup {
            let remoteDataSource = CocktailsRemoteDataSourceImpl()
            let repository = CocktailsRepositoryImpl(remoteDataSource: remoteDataSource)
            RootView()
                .environmentObject(RootViewModel(repository: repository))
        }
    }
}
