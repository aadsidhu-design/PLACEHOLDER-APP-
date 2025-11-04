import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseAnalytics

class FirebaseService: NSObject, ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User? = nil
    @Published var errorMessage: String? = nil
    
    static let shared = FirebaseService()
    let db = Firestore.firestore()
    
    override private init() {
        super.init()
    }
    
    // MARK: - Auth
    
    func signUp(email: String, password: String, displayName: String) async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        let user = User(
            id: result.user.uid,
            email: email,
            displayName: displayName,
            createdAt: Date(),
            skillsets: [],
            interests: [],
            personalityTraits: [],
            riskTolerance: "medium",
            availableHoursPerWeek: 0,
            budgetRange: "$0-500",
            location: nil
        )
        try await saveUser(user)
        self.currentUser = user
        self.isAuthenticated = true
        Analytics.logEvent("user_signup", parameters: ["email": email])
    }
    
    func signIn(email: String, password: String) async throws {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        let user = try await fetchUser(id: result.user.uid)
        self.currentUser = user
        self.isAuthenticated = true
        Analytics.logEvent("user_signin", parameters: ["email": email])
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        self.currentUser = nil
        self.isAuthenticated = false
        Analytics.logEvent("user_signout", parameters: nil)
    }
    
    // MARK: - User CRUD
    
    func saveUser(_ user: User) async throws {
        guard let uid = user.id else { throw NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID is nil"]) }
        try db.collection("users").document(uid).setData(from: user)
    }
    
    func fetchUser(id: String) async throws -> User {
        let doc = try await db.collection("users").document(id).getDocument(as: User.self)
        return doc
    }
    
    func updateUser(_ user: User) async throws {
        guard let uid = user.id else { throw NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID is nil"]) }
        try db.collection("users").document(uid).setData(from: user, merge: true)
    }
    
    // MARK: - Quiz CRUD
    
    func saveQuizResponse(_ response: QuizResponse) async throws {
        let docRef = try db.collection("quizResponses").addDocument(from: response)
        Analytics.logEvent("quiz_completed", parameters: [
            "user_id": response.userId,
            "doc_id": docRef.documentID
        ])
    }
    
    func fetchQuizResponse(userId: String) async throws -> QuizResponse? {
        let query = db.collection("quizResponses").whereField("userId", isEqualTo: userId).order(by: "createdAt", descending: true).limit(to: 1)
        let snapshot = try await query.getDocuments()
        return snapshot.documents.first.flatMap { try? $0.data(as: QuizResponse.self) }
    }
    
    // MARK: - Business Idea CRUD
    
    func saveBusinessIdea(_ idea: BusinessIdea) async throws {
        let docRef = try db.collection("businessIdeas").addDocument(from: idea)
        Analytics.logEvent("idea_generated", parameters: [
            "idea_title": idea.title,
            "user_id": idea.userId
        ])
    }
    
    func fetchBusinessIdeas(userId: String) async throws -> [BusinessIdea] {
        let query = db.collection("businessIdeas").whereField("userId", isEqualTo: userId).order(by: "createdAt", descending: true)
        let snapshot = try await query.getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: BusinessIdea.self) }
    }
    
    func updateBusinessIdea(_ idea: BusinessIdea) async throws {
        guard let id = idea.id else { throw NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Idea ID is nil"]) }
        try db.collection("businessIdeas").document(id).setData(from: idea, merge: true)
    }
    
    // MARK: - Goal CRUD
    
    func saveGoal(_ goal: Goal) async throws {
        try db.collection("goals").addDocument(from: goal)
    }
    
    func fetchGoals(userId: String) async throws -> [Goal] {
        let query = db.collection("goals").whereField("userId", isEqualTo: userId).order(by: "dueDate", descending: false)
        let snapshot = try await query.getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: Goal.self) }
    }
    
    func updateGoal(_ goal: Goal) async throws {
        guard let id = goal.id else { throw NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Goal ID is nil"]) }
        try db.collection("goals").document(id).setData(from: goal, merge: true)
    }
    
    // MARK: - Milestone CRUD
    
    func saveMilestone(_ milestone: Milestone) async throws {
        try db.collection("milestones").addDocument(from: milestone)
    }
    
    func fetchMilestones(ideaId: String) async throws -> [Milestone] {
        let query = db.collection("milestones").whereField("ideaId", isEqualTo: ideaId).order(by: "startDate", descending: false)
        let snapshot = try await query.getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: Milestone.self) }
    }
    
    func updateMilestone(_ milestone: Milestone) async throws {
        guard let id = milestone.id else { throw NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Milestone ID is nil"]) }
        try db.collection("milestones").document(id).setData(from: milestone, merge: true)
    }
}
