import Foundation

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    let email: String
    let displayName: String?
    let createdAt: Date
    let skillsets: [String]
    let interests: [String]
    let personalityTraits: [String]
    let riskTolerance: String // "low", "medium", "high"
    let availableHoursPerWeek: Int
    let budgetRange: String // "$0-500", "$500-2000", "$2000+"
    let location: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case email
        case displayName
        case createdAt
        case skillsets
        case interests
        case personalityTraits
        case riskTolerance
        case availableHoursPerWeek
        case budgetRange
        case location
    }
}
