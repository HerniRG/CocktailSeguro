//
//  RootView.swift
//  CocktailSeguro
//
//  Created by Hernán Rodríguez on 12/1/25.
//


import SwiftUI

struct RootView: View {
    @EnvironmentObject var viewModel: RootViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)").foregroundColor(.red)
                } else {
                    List(viewModel.categories, id: \.self) { category in
                        Text(category)
                    }
                }
            }
            .navigationTitle("Cocktail Categories")
            .onAppear {
                Task {
                    await viewModel.loadCategories()
                }
            }
        }
    }
}