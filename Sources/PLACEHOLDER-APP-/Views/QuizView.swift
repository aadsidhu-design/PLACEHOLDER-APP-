
import SwiftUI

struct QuizView: View {
    @StateObject private var viewModel = QuizViewModel()

    var body: some View {
        VStack {
            Text("Quiz")
                .font(.largeTitle)
                .padding()

            if viewModel.quizQuestions.indices.contains(viewModel.currentQuestionIndex) {
                let question = viewModel.quizQuestions[viewModel.currentQuestionIndex]
                Text(question.question)
                    .font(.title)
                    .padding()

                ForEach(question.options, id: \.self) { option in
                    Button(action: {
                        viewModel.selectOption(option)
                    }) {
                        Text(option)
                            .font(.title2)
                            .padding()
                            .background(viewModel.quizQuestions[viewModel.currentQuestionIndex].selectedOption == option ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }

                if viewModel.currentQuestionIndex < viewModel.quizQuestions.count - 1 {
                    Button(action: {
                        viewModel.nextQuestion()
                    }) {
                        Text("Next")
                            .font(.title)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                } else {
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
    }
}
