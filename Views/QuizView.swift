import SwiftUI

struct QuizView: View {
    @EnvironmentObject var quizViewModel: QuizViewModel
    @EnvironmentObject var ideaViewModel: IdeaViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedOption: String? = nil
    @State private var selectedCheckboxes: Set<String> = []
    @State private var sliderValue: Double = 0.5
    @State private var textInput: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            // Progress Bar
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Question \(quizViewModel.currentQuestionIndex + 1) of \(quizViewModel.quizEngine.questions.count)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("\(Int(quizViewModel.progress * 100))%")
                        .font(.caption)
                        .fontWeight(.bold)
                }
                
                ProgressView(value: quizViewModel.progress)
                    .tint(.blue)
            }
            .padding()
            
            // Question
            if let question = quizViewModel.currentQuestion {
                VStack(alignment: .leading, spacing: 16) {
                    Text(question.text)
                        .font(.headline)
                        .lineLimit(nil)
                    
                    // Answer Options based on type
                    switch question.questionType {
                    case .multipleChoice:
                        VStack(spacing: 12) {
                            ForEach(question.options ?? [], id: \.self) { option in
                                Button(action: {
                                    selectedOption = option
                                    quizViewModel.recordAnswer(.string(option))
                                }) {
                                    HStack {
                                        Text(option)
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Image(systemName: selectedOption == option ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(selectedOption == option ? .blue : .gray)
                                    }
                                    .padding()
                                    .background(selectedOption == option ? Color.blue.opacity(0.1) : Color(.systemGray6))
                                    .cornerRadius(8)
                                }
                            }
                        }
                        
                    case .checkboxes:
                        VStack(spacing: 12) {
                            ForEach(question.options ?? [], id: \.self) { option in
                                Button(action: {
                                    if selectedCheckboxes.contains(option) {
                                        selectedCheckboxes.remove(option)
                                    } else {
                                        selectedCheckboxes.insert(option)
                                    }
                                    let selections = Array(selectedCheckboxes)
                                    quizViewModel.recordAnswer(.array(selections.map { .string($0) }))
                                }) {
                                    HStack {
                                        Text(option)
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Image(systemName: selectedCheckboxes.contains(option) ? "checkmark.square.fill" : "square")
                                            .foregroundColor(selectedCheckboxes.contains(option) ? .blue : .gray)
                                    }
                                    .padding()
                                    .background(selectedCheckboxes.contains(option) ? Color.blue.opacity(0.1) : Color(.systemGray6))
                                    .cornerRadius(8)
                                }
                            }
                        }
                        
                    case .slider:
                        VStack(spacing: 12) {
                            Slider(value: $sliderValue, in: 0...100)
                                .onChange(of: sliderValue) { newValue in
                                    quizViewModel.recordAnswer(.double(newValue))
                                }
                            
                            Text("\(Int(sliderValue))")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                        
                    case .textInput:
                        TextField("Your answer", text: $textInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: textInput) { newValue in
                                quizViewModel.recordAnswer(.string(newValue))
                            }
                    }
                    
                    Spacer()
                }
                .padding()
            }
            
            // Navigation Buttons
            HStack(spacing: 12) {
                if quizViewModel.currentQuestionIndex > 0 {
                    Button(action: quizViewModel.previousQuestion) {
                        Text("Back")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .foregroundColor(.blue)
                            .cornerRadius(8)
                    }
                }
                
                Button(action: {
                    if quizViewModel.isLastQuestion {
                        // Submit quiz
                        Task {
                            await quizViewModel.submitQuiz(userId: authViewModel.firebaseService.currentUser?.id ?? "unknown")
                        }
                    } else {
                        quizViewModel.nextQuestion()
                    }
                }) {
                    Text(quizViewModel.isLastQuestion ? "Submit" : "Next")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .navigationTitle("Business Quiz")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    QuizView()
        .environmentObject(QuizViewModel())
        .environmentObject(IdeaViewModel())
        .environmentObject(AuthViewModel())
}
