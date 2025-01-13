import SwiftUI

struct NoResultsView: View {
    let message: String

    var body: some View {
        Text(message)
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
            .padding()
    }
}
