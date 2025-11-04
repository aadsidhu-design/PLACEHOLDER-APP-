import Foundation

class GoogleAIService {
    static let shared = GoogleAIService()
    
    // MARK: - Configuration
    private let apiKey = SecureConfig.googleAIKey
    private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent"
    
    init() {
        if !SecureConfig.validateConfiguration() {
            print("⚠️ GoogleAIService: Configuration validation failed")
        }
    }
    
    // MARK: - AI Idea Generation
    
    func generateBusinessIdeas(from quizResponse: QuizResponse, userProfile: User) async throws -> [BusinessIdea] {
        guard !apiKey.isEmpty else {
            throw AIServiceError.configurationMissing("Google AI API key not configured")
        }
        
        let profileDescription = formatProfileForPrompt(quizResponse, userProfile)
        let prompt = buildIdeaGenerationPrompt(profileDescription)
        
        let requestBody = AIGenerateRequest(contents: [Content(parts: [Part(text: prompt)])])
        let jsonData = try JSONEncoder().encode(requestBody)
        
        var request = URLRequest(url: URL(string: baseURL + "?key=" + apiKey)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        request.timeoutInterval = 30
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw AIServiceError.invalidResponse
        }
        
        let aiResponse = try JSONDecoder().decode(AIGenerateResponse.self, from: data)
        let ideas = try parseIdeasFromAIResponse(aiResponse, userId: userProfile.id ?? "unknown")
        
        return ideas
    }
    
    // MARK: - Private Helpers
    
    private func formatProfileForPrompt(_ quiz: QuizResponse, _ user: User) -> String {
        return """
        User Profile:
        - Skills: \(user.skillsets.joined(separator: ", "))
        - Interests: \(user.interests.joined(separator: ", "))
        - Personality: \(user.personalityTraits.joined(separator: ", "))
        - Risk Tolerance: \(user.riskTolerance)
        - Available Hours/Week: \(user.availableHoursPerWeek)
        - Budget: \(user.budgetRange)
        - Location: \(user.location ?? "Not specified")
        """
    }
    
    private func buildIdeaGenerationPrompt(_ profileDescription: String) -> String {
        return """
        You are a business idea generator. Given the user profile below, generate exactly 3 personalized business ideas.
        
        \(profileDescription)
        
        For each idea, provide a JSON object with these fields:
        - title (string, 3-5 words)
        - summary (string, 1-2 sentences)
        - detailedDescription (string, 2-3 paragraphs)
        - requiredSkills (array of strings)
        - roughTimelineWeeks (integer, estimated weeks to MVP)
        - first30DayPlan (array of 8-10 task strings)
        - revenueModelHint (string, brief explanation)
        - estimatedStartupCostRange (string, e.g. "$500-$2000")
        - tags (array of strings, up to 5)
        
        Return a JSON array with exactly 3 objects. Ensure all ideas are realistic, actionable, and tailored to the user's profile.
        """
    }
    
    private func parseIdeasFromAIResponse(_ response: AIGenerateResponse, userId: String) throws -> [BusinessIdea] {
        guard let firstCandidate = response.candidates.first,
              let firstContent = firstCandidate.content.parts.first,
              let textContent = firstContent.text else {
            throw AIServiceError.noValidResponse
        }
        
        // Extract JSON array from response (might be wrapped in markdown code blocks)
        let cleanedText = textContent
            .replacingOccurrences(of: "```json\n", with: "")
            .replacingOccurrences(of: "```\n", with: "")
            .replacingOccurrences(of: "```", with: "")
        
        let jsonData = cleanedText.data(using: .utf8)!
        let ideaDicts = try JSONDecoder().decode([[String: AnyCodable]].self, from: jsonData)
        
        var ideas: [BusinessIdea] = []
        for dict in ideaDicts {
            let idea = BusinessIdea(
                id: UUID().uuidString,
                userId: userId,
                title: extractString(dict["title"]) ?? "Untitled",
                summary: extractString(dict["summary"]) ?? "",
                detailedDescription: extractString(dict["detailedDescription"]) ?? "",
                requiredSkills: extractArray(dict["requiredSkills"]) ?? [],
                roughTimelineWeeks: extractInt(dict["roughTimelineWeeks"]) ?? 12,
                first30DayPlan: extractArray(dict["first30DayPlan"]) ?? [],
                revenueModelHint: extractString(dict["revenueModelHint"]) ?? "",
                estimatedStartupCostRange: extractString(dict["estimatedStartupCostRange"]) ?? "$0-500",
                aiPromptUsed: nil,
                tags: extractArray(dict["tags"]) ?? [],
                createdAt: Date()
            )
            ideas.append(idea)
        }
        
        return ideas
    }
    
    private func extractString(_ value: AnyCodable?) -> String? {
        guard let value = value else { return nil }
        if case .string(let str) = value {
            return str
        }
        return nil
    }
    
    private func extractInt(_ value: AnyCodable?) -> Int? {
        guard let value = value else { return nil }
        if case .int(let int) = value {
            return int
        } else if case .double(let dbl) = value {
            return Int(dbl)
        }
        return nil
    }
    
    private func extractArray(_ value: AnyCodable?) -> [String]? {
        guard let value = value else { return nil }
        if case .array(let arr) = value {
            return arr.compactMap { v in
                if case .string(let str) = v {
                    return str
                }
                return nil
            }
        }
        return nil
    }
}

// MARK: - Request/Response Models

struct AIGenerateRequest: Encodable {
    let contents: [Content]
}

struct Content: Encodable {
    let parts: [Part]
}

struct Part: Encodable {
    let text: String
}

struct AIGenerateResponse: Decodable {
    let candidates: [Candidate]
}

struct Candidate: Decodable {
    let content: ContentResponse
}

struct ContentResponse: Decodable {
    let parts: [PartResponse]
}

struct PartResponse: Decodable {
    let text: String?
}

enum AIServiceError: Error, LocalizedError {
    case invalidResponse
    case noValidResponse
    case decodingError
    case networkError
    case configurationMissing(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from AI service"
        case .noValidResponse:
            return "No valid response from AI"
        case .decodingError:
            return "Failed to decode AI response"
        case .networkError:
            return "Network error while calling AI service"
        case .configurationMissing(let reason):
            return "Configuration error: \(reason)"
        }
    }
}
