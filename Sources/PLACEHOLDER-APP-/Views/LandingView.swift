
import SwiftUI

struct LandingView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Welcome to Business Idea Generator")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                
                NavigationLink(destination: QuizView()) {
                    Text("Start Quiz")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                Spacer()
            }
            .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
        }
    }
}
