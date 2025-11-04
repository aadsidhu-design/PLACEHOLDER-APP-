import SwiftUI

// MARK: - Business Idea Model
struct BusinessIdea: Identifiable, Codable {
    let id: String
    var title: String
    var description: String
    var category: String
    var marketPotential: String
    var estimatedBudget: String
    var timeToMarket: String
    var details: String
    var createdAt: Date = Date()
}
