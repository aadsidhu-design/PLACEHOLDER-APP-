
import Foundation

class QuizViewModel: ObservableObject {
    @Published var quizQuestions: [QuizQuestion] = []
    @Published var currentQuestionIndex = 0

    init() {
        loadQuestions()
    }

    func loadQuestions() {
        // Placeholder questions
        quizQuestions = [
            QuizQuestion(question: "What is your primary skill?", options: ["Technical", "Creative", "Business", "People Skills"]),
            QuizQuestion(question: "What are you passionate about?", options: ["Technology", "Art", "Helping Others", "Building Things"]),
            QuizQuestion(question: "What is your work style?", options: ["I like to work alone", "I like to work in a team", "I am a leader", "I am a follower"])
        ]
    }

    func selectOption(_ option: String) {
        quizQuestions[currentQuestionIndex].selectedOption = option
    }

    func nextQuestion() {
        if currentQuestionIndex < quizQuestions.count - 1 {
            currentQuestionIndex += 1
        }
    }
}
