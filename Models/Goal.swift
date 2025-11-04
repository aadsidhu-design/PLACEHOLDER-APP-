import Foundation

struct Goal: Codable, Identifiable {
    @DocumentID var id: String?
    let ideaId: String
    let userId: String
    let title: String
    let description: String?
    let dueDate: Date
    let status: GoalStatus // "pending", "in_progress", "completed"
    let priority: GoalPriority // "low", "medium", "high"
    let createdAt: Date
    var completedAt: Date? = nil
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case ideaId
        case userId
        case title
        case description
        case dueDate
        case status
        case priority
        case createdAt
        case completedAt
    }
}

enum GoalStatus: String, Codable {
    case pending
    case inProgress = "in_progress"
    case completed
}

enum GoalPriority: String, Codable {
    case low
    case medium
    case high
}
