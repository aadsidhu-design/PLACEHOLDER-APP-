import SwiftUI

// MARK: - Quiz Response Model
struct QuizResponse: Identifiable, Codable {
    let id: String
    var userId: String
    var answers: [Int]
    var score: Int
    var timestamp: Date
}

// MARK: - Quiz Question Model
struct QuizQuestion: Identifiable, Codable {
    let id: UUID = UUID()
    let question: String
    let options: [String]
    let correctAnswer: Int
}
