import SwiftUI

struct CocktailRowView: View {
    let cocktail: Cocktail
    
    var body: some View {
        
        HStack {
            AsyncImage(url: URL(string: cocktail.strDrinkThumb ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
                    .frame(width: 50, height: 50)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(cocktail.strDrink)
                    .font(.headline)
                if let category = cocktail.strCategory {
                    Text(category)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}
