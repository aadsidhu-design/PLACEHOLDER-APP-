
import SwiftUI

struct LandingView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to Business Idea Generator")
                    .font(.largeTitle)
                    .padding()
                NavigationLink(destination: QuizView()) {
                    Text("Start Quiz")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}
