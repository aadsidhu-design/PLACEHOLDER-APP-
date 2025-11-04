
import SwiftUI

struct AIAssistantView: View {
    @StateObject private var viewModel = AIAssistantViewModel()
    @State private var interests: String = ""

    var body: some View {
        VStack {
            Text("AI Assistant")
                .font(.largeTitle)
                .padding()

            TextField("Enter your interests (comma separated)", text: $interests)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                let interestsArray = interests.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) }
                viewModel.getBusinessIdeas(userInterests: interestsArray)
            }) {
                Text("Get Business Ideas")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Text(viewModel.response)
                .padding()
        }
    }
}
