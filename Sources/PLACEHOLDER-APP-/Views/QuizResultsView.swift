
import SwiftUI

struct QuizResultsView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Quiz Results")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            Text("Based on your answers, here are your business ideas.")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
            
            NavigationLink(destination: BusinessIdeasView()) {
                Text("See Business Ideas")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
    }
}
