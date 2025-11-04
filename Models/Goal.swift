import SwiftUI

// MARK: - Goal Model
struct Goal: Identifiable, Codable {
    let id: String
    var title: String
    var description: String
    var priority: GoalPriority
    var status: GoalStatus
    var dueDate: Date?
    var milestones: [Milestone]
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
}

enum GoalPriority: String, Codable, CaseIterable {
    case high = "high"
    case medium = "medium"
    case low = "low"
}

enum GoalStatus: String, Codable {
    case pending = "pending"
    case inProgress = "in_progress"
    case completed = "completed"
    
    var displayName: String {
        switch self {
        case .pending:
            return "Pending"
        case .inProgress:
            return "In Progress"
        case .completed:
            return "Completed"
        }
    }
}
