import Foundation
import Combine

class QuizViewModel: ObservableObject {
    @Published var currentQuestionIndex = 0
    @Published var answers: [String: AnyCodable] = [:]
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var quizCompleted = false
    
    let quizEngine = QuizEngine.shared
    private let firebaseService = FirebaseService.shared
    
    var currentQuestion: QuizQuestion? {
        guard currentQuestionIndex < quizEngine.questions.count else { return nil }
        return quizEngine.questions[currentQuestionIndex]
    }
    
    var progress: Double {
        Double(currentQuestionIndex) / Double(quizEngine.questions.count)
    }
    
    var isLastQuestion: Bool {
        currentQuestionIndex == quizEngine.questions.count - 1
    }
    
    func recordAnswer(_ value: AnyCodable) {
        guard let fieldKey = currentQuestion?.fieldKey else { return }
        answers[fieldKey] = value
    }
    
    func nextQuestion() {
        if currentQuestionIndex < quizEngine.questions.count - 1 {
            currentQuestionIndex += 1
        }
    }
    
    func previousQuestion() {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
        }
    }
    
    func submitQuiz(userId: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let profileVector = quizEngine.calculateProfileVector(answers: answers)
            let quizResponse = QuizResponse(
                userId: userId,
                answers: answers,
                profileVector: profileVector,
                createdAt: Date()
            )
            
            try await firebaseService.saveQuizResponse(quizResponse)
            quizCompleted = true
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
