import Foundation

struct BusinessIdea: Codable, Identifiable {
    @DocumentID var id: String?
    let userId: String
    let title: String
    let summary: String // 1–2 lines
    let detailedDescription: String
    let requiredSkills: [String]
    let roughTimelineWeeks: Int
    let first30DayPlan: [String] // Array of tasks
    let revenueModelHint: String
    let estimatedStartupCostRange: String // e.g., "$500-$2000"
    let aiPromptUsed: String? // For debugging
    let tags: [String]
    let createdAt: Date
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId
        case title
        case summary
        case detailedDescription
        case requiredSkills
        case roughTimelineWeeks
        case first30DayPlan
        case revenueModelHint
        case estimatedStartupCostRange
        case aiPromptUsed
        case tags
        case createdAt
        case isFavorite
    }
}
