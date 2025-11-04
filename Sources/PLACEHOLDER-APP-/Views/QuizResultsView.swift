
import SwiftUI

struct QuizResultsView: View {
    var body: some View {
        VStack {
            Text("Quiz Results")
                .font(.largeTitle)
                .padding()
            Text("Based on your answers, here are your business ideas.")
            NavigationLink(destination: BusinessIdeasView()) {
                Text("See Business Ideas")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}
