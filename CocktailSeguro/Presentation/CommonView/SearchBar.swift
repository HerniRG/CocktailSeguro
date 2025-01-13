import SwiftUI

struct SearchBar: View {
    @Binding var query: String
    let placeholder: String
    let onSearch: () -> Void

    var body: some View {
        HStack {
            TextField(placeholder, text: $query)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button(action: onSearch) {
                Image(systemName: "magnifyingglass")
                    .padding(10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Circle())
            }
        }
        .padding()
    }
}
