import Foundation

struct Milestone: Codable, Identifiable {
    @DocumentID var id: String?
    let ideaId: String
    let userId: String
    let title: String
    let description: String?
    let startDate: Date
    let endDate: Date
    let progress: Double // 0.0 to 1.0
    let goals: [String]? // IDs of associated goals
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case ideaId
        case userId
        case title
        case description
        case startDate
        case endDate
        case progress
        case goals
        case createdAt
    }
}
