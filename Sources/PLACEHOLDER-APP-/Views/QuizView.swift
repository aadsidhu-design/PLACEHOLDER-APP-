
import SwiftUI

struct QuizView: View {
    @StateObject private var viewModel = QuizViewModel()

    var body: some View {
        VStack {
            Text("Quiz")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            if viewModel.quizQuestions.indices.contains(viewModel.currentQuestionIndex) {
                let question = viewModel.quizQuestions[viewModel.currentQuestionIndex]
                Text(question.question)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding()

                VStack(spacing: 10) {
                    ForEach(question.options, id: \.self) { option in
                        Button(action: {
                            viewModel.selectOption(option)
                        }) {
                            Text(option)
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(viewModel.quizQuestions[viewModel.currentQuestionIndex].selectedOption == option ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                    }
                }

                Spacer()

                if viewModel.currentQuestionIndex < viewModel.quizQuestions.count - 1 {
                    Button(action: {
                        viewModel.nextQuestion()
                    }) {
                        Text("Next")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                } else {
                    NavigationLink(destination: QuizResultsView()) {
                        Text("Submit")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
            }
        }
        .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
    }
}
