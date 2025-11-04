# API Reference

## FirebaseService

Handles authentication, database CRUD, and analytics.

### Authentication

```swift
// Sign up
try await firebaseService.signUp(email: String, password: String, displayName: String)

// Sign in
try await firebaseService.signIn(email: String, password: String)

// Sign out
try firebaseService.signOut()
```

### User CRUD

```swift
// Save user
try await firebaseService.saveUser(_ user: User)

// Fetch user
let user = try await firebaseService.fetchUser(id: String)

// Update user
try await firebaseService.updateUser(_ user: User)
```

### Quiz CRUD

```swift
// Save quiz response
try await firebaseService.saveQuizResponse(_ response: QuizResponse)

// Fetch latest quiz
let quiz = try await firebaseService.fetchQuizResponse(userId: String)
```

### Business Idea CRUD

```swift
// Save idea
try await firebaseService.saveBusinessIdea(_ idea: BusinessIdea)

// Fetch ideas for user
let ideas = try await firebaseService.fetchBusinessIdeas(userId: String)

// Update idea
try await firebaseService.updateBusinessIdea(_ idea: BusinessIdea)
```

### Goal CRUD

```swift
// Save goal
try await firebaseService.saveGoal(_ goal: Goal)

// Fetch goals
let goals = try await firebaseService.fetchGoals(userId: String)

// Update goal
try await firebaseService.updateGoal(_ goal: Goal)
```

### Milestone CRUD

```swift
// Save milestone
try await firebaseService.saveMilestone(_ milestone: Milestone)

// Fetch milestones
let milestones = try await firebaseService.fetchMilestones(ideaId: String)

// Update milestone
try await firebaseService.updateMilestone(_ milestone: Milestone)
```

## GoogleAIService

Generates personalized business ideas via Gemini API.

### Idea Generation

```swift
let ideas = try await googleAIService.generateBusinessIdeas(
    from: quizResponse,
    userProfile: user
)
// Returns: [BusinessIdea] array (typically 3 ideas)
```

**Input:**
- `quizResponse: QuizResponse` — User's quiz answers & profile vector
- `userProfile: User` — User skills, interests, constraints

**Output:**
- Array of `BusinessIdea` objects with title, summary, 30-day plan, timeline, cost estimate

**Error Handling:**
- `AIServiceError.invalidResponse` — HTTP error from API
- `AIServiceError.noValidResponse` — Empty or malformed response
- `AIServiceError.decodingError` — JSON parsing failed
- `AIServiceError.networkError` — Network unavailable

## QuizEngine

Quiz logic, questions, and scoring.

### Quiz Questions

```swift
let questions = quizEngine.questions
// Returns array of 10 QuizQuestion objects
```

Question types:
- `.multipleChoice` — Select one option
- `.checkboxes` — Select multiple options
- `.slider` — Numeric range
- `.textInput` — Free text

### Scoring

```swift
let profileVector = quizEngine.calculateProfileVector(answers: answers)
// Returns ProfileVector with scores 0.0–1.0 for:
//   - skillScore
//   - interestScore
//   - personalityScore
//   - riskScore
//   - resourceScore
```

## ViewModels

### AuthViewModel

```swift
class AuthViewModel: ObservableObject {
    @Published var email: String
    @Published var password: String
    @Published var displayName: String
    @Published var isLoading: Bool
    @Published var errorMessage: String?
    @Published var isAuthenticated: Bool
    
    func signUp() async
    func signIn() async
    func signOut()
}
```

### QuizViewModel

```swift
class QuizViewModel: ObservableObject {
    @Published var currentQuestionIndex: Int
    @Published var answers: [String: AnyCodable]
    @Published var isLoading: Bool
    @Published var errorMessage: String?
    @Published var quizCompleted: Bool
    
    var currentQuestion: QuizQuestion?
    var progress: Double
    var isLastQuestion: Bool
    
    func recordAnswer(_ value: AnyCodable)
    func nextQuestion()
    func previousQuestion()
    func submitQuiz(userId: String) async
}
```

### IdeaViewModel

```swift
class IdeaViewModel: ObservableObject {
    @Published var businessIdeas: [BusinessIdea]
    @Published var selectedIdea: BusinessIdea?
    @Published var isLoading: Bool
    @Published var errorMessage: String?
    @Published var ideasGenerated: Bool
    
    func generateIdeas(from quizResponse: QuizResponse, userProfile: User) async
    func fetchIdeas(userId: String) async
    func toggleFavorite(for idea: BusinessIdea) async
}
```

### GoalViewModel

```swift
class GoalViewModel: ObservableObject {
    @Published var goals: [Goal]
    @Published var milestones: [Milestone]
    @Published var isLoading: Bool
    @Published var errorMessage: String?
    
    func fetchGoals(userId: String) async
    func addGoal(_ goal: Goal) async
    func updateGoal(_ goal: Goal) async
    func fetchMilestones(ideaId: String) async
    func addMilestone(_ milestone: Milestone) async
    func updateMilestone(_ milestone: Milestone) async
}
```

## Data Models

All models conform to `Codable` and `Identifiable` for SwiftUI and Firebase compatibility.

### User

```swift
struct User: Codable, Identifiable {
    var id: String?
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
}
```

### QuizResponse

```swift
struct QuizResponse: Codable, Identifiable {
    var id: String?
    let userId: String
    let answers: [String: AnyCodable]
    let profileVector: ProfileVector
    let createdAt: Date
}

struct ProfileVector: Codable {
    let skillScore: Double
    let interestScore: Double
    let personalityScore: Double
    let riskScore: Double
    let resourceScore: Double
}
```

### BusinessIdea

```swift
struct BusinessIdea: Codable, Identifiable {
    var id: String?
    let userId: String
    let title: String
    let summary: String
    let detailedDescription: String
    let requiredSkills: [String]
    let roughTimelineWeeks: Int
    let first30DayPlan: [String]
    let revenueModelHint: String
    let estimatedStartupCostRange: String
    let aiPromptUsed: String?
    let tags: [String]
    let createdAt: Date
    var isFavorite: Bool
}
```

### Goal

```swift
struct Goal: Codable, Identifiable {
    var id: String?
    let ideaId: String
    let userId: String
    let title: String
    let description: String?
    let dueDate: Date
    let status: GoalStatus // "pending", "in_progress", "completed"
    let priority: GoalPriority // "low", "medium", "high"
    let createdAt: Date
    var completedAt: Date?
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
```

### Milestone

```swift
struct Milestone: Codable, Identifiable {
    var id: String?
    let ideaId: String
    let userId: String
    let title: String
    let description: String?
    let startDate: Date
    let endDate: Date
    let progress: Double // 0.0 to 1.0
    let goals: [String]?
    let createdAt: Date
}
```

## Error Handling

### Common Errors

```swift
enum FirebaseServiceError: Error {
    case authenticationFailed
    case userNotFound
    case databaseError(String)
}

enum AIServiceError: Error {
    case invalidResponse
    case noValidResponse
    case decodingError
    case networkError
}
```

### Usage

```swift
do {
    try await firebaseService.signIn(email: email, password: password)
} catch {
    print("Sign in failed: \(error.localizedDescription)")
}
```

## Configuration

See `Config/Config.swift` for app-wide constants:

```swift
struct Config {
    static let googleAIKey: String = ProcessInfo.processInfo.environment["GOOGLE_AI_API_KEY"] ?? ""
    static let firebaseProjectID = "studio-5837146656-10acf"
    static let firebaseProjectNumber = "1095936176351"
    static let firebaseWebAPIKey = "AIzaSyD0yDZFbfJd68FOL2jPVbopg8UEUOd3tXQ"
    static let appName = "BusinessIdea"
    static let appVersion = "1.0.0"
    static let minimumIOSVersion = "14.0"
}
```

## Analytics Events

Fired automatically by `FirebaseService`:

- `user_signup` — User created account
- `user_signin` — User signed in
- `user_signout` — User signed out
- `quiz_completed` — User finished quiz
- `idea_generated` — AI generated ideas

Access via Firebase Analytics dashboard.
