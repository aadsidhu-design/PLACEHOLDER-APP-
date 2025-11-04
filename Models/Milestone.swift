import SwiftUI

// MARK: - Milestone Model
struct Milestone: Identifiable, Codable {
    let id: String
    var title: String
    var description: String?
    var isCompleted: Bool
    var dueDate: Date?
    var completedDate: Date?
}
