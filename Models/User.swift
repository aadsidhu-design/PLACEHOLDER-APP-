import SwiftUI

// MARK: - User Model
struct User: Identifiable, Codable {
    let id: String
    var displayName: String
    var email: String
    var createdAt: Date
    var quizCompleted: Bool
    var subscriptionTier: SubscriptionTier
}

enum SubscriptionTier: String, Codable {
    case free = "free"
    case pro = "pro"
    case premium = "premium"
}
