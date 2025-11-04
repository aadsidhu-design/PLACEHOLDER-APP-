
import SwiftUI

struct QuizView: View {
    var body: some View {
        VStack {
            Text("Quiz")
                .font(.largeTitle)
                .padding()
            Text("Quiz questions will go here.")
            NavigationLink(destination: QuizResultsView()) {
                Text("Submit")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}
