import Foundation

struct QuizQuestion: Identifiable {
    let id: UUID = UUID()
    let text: String
    let questionType: QuestionType
    let options: [String]? // For multiple choice
    let fieldKey: String // Key to store answer in response dict
    
    enum QuestionType {
        case multipleChoice
        case checkboxes
        case slider
        case textInput
    }
}

class QuizEngine {
    static let shared = QuizEngine()
    
    let questions: [QuizQuestion] = [
        // Section 1: Skills & Experience
        QuizQuestion(
            text: "What's your primary professional background?",
            questionType: .multipleChoice,
            options: ["Technology/Engineering", "Business/Finance", "Creative/Design", "Marketing/Sales", "Healthcare", "Education", "Other"],
            fieldKey: "professionalBackground"
        ),
        QuizQuestion(
            text: "Select your top skills (choose up to 5):",
            questionType: .checkboxes,
            options: ["Leadership", "Problem-solving", "Communication", "Technical", "Data analysis", "Project management", "Sales", "Writing", "Design", "Other"],
            fieldKey: "topSkills"
        ),
        QuizQuestion(
            text: "Years of work experience?",
            questionType: .multipleChoice,
            options: ["0-2 years", "2-5 years", "5-10 years", "10+ years"],
            fieldKey: "experienceLevel"
        ),
        
        // Section 2: Interests & Industry
        QuizQuestion(
            text: "What industries interest you most? (select up to 3)",
            questionType: .checkboxes,
            options: ["Tech/Software", "E-commerce", "SaaS", "Healthcare", "Education", "Finance", "Sustainability", "Entertainment", "Real Estate", "Food/Beverage"],
            fieldKey: "interestedIndustries"
        ),
        QuizQuestion(
            text: "What's your ideal customer?",
            questionType: .multipleChoice,
            options: ["B2B (businesses)", "B2C (consumers)", "B2B2C (both)", "Not sure yet"],
            fieldKey: "customerType"
        ),
        
        // Section 3: Working Style & Personality
        QuizQuestion(
            text: "How do you prefer to work?",
            questionType: .multipleChoice,
            options: ["Solo/independent", "Small team", "Collaborative/large team", "Mixed"],
            fieldKey: "workingStyle"
        ),
        QuizQuestion(
            text: "What's your risk tolerance?",
            questionType: .multipleChoice,
            options: ["Low (stable income priority)", "Medium (balanced)", "High (growth priority)"],
            fieldKey: "riskTolerance"
        ),
        
        // Section 4: Resources
        QuizQuestion(
            text: "How many hours per week can you dedicate?",
            questionType: .multipleChoice,
            options: ["1-10 hours", "10-20 hours", "20-40 hours", "40+ hours"],
            fieldKey: "availableHours"
        ),
        QuizQuestion(
            text: "Initial budget for startup?",
            questionType: .multipleChoice,
            options: ["$0-500", "$500-2000", "$2000-5000", "$5000+"],
            fieldKey: "initialBudget"
        ),
        
        // Section 5: Constraints
        QuizQuestion(
            text: "Any constraints? (select all that apply)",
            questionType: .checkboxes,
            options: ["Location-dependent", "Must keep current job", "Limited tech skills", "No team available", "Regulatory concerns"],
            fieldKey: "constraints"
        ),
    ]
    
    func calculateProfileVector(answers: [String: AnyCodable]) -> ProfileVector {
        // Simplified scoring logic
        let skillScore = Double(answers["topSkills"].flatMap { value in
            if case .array(let arr) = value { return arr.count } else { return 0 }
        } ?? 0) / 5.0
        
        let interestScore = Double(answers["interestedIndustries"].flatMap { value in
            if case .array(let arr) = value { return arr.count } else { return 0 }
        } ?? 0) / 3.0
        
        let riskScore = extractRiskScore(from: answers["riskTolerance"])
        let resourceScore = extractResourceScore(from: answers["availableHours"], and: answers["initialBudget"])
        
        return ProfileVector(
            skillScore: min(skillScore, 1.0),
            interestScore: min(interestScore, 1.0),
            personalityScore: 0.5, // Placeholder
            riskScore: riskScore,
            resourceScore: resourceScore
        )
    }
    
    private func extractRiskScore(from value: AnyCodable?) -> Double {
        guard let value = value, case .string(let str) = value else { return 0.5 }
        switch str {
        case "Low (stable income priority)": return 0.3
        case "Medium (balanced)": return 0.5
        case "High (growth priority)": return 0.8
        default: return 0.5
        }
    }
    
    private func extractResourceScore(from hoursValue: AnyCodable?, and budgetValue: AnyCodable?) -> Double {
        var score = 0.0
        
        if let hours = hoursValue, case .string(let str) = hours {
            switch str {
            case "1-10 hours": score += 0.25
            case "10-20 hours": score += 0.5
            case "20-40 hours": score += 0.75
            case "40+ hours": score += 1.0
            default: break
            }
        }
        
        if let budget = budgetValue, case .string(let str) = budget {
            switch str {
            case "$0-500": score += 0.25
            case "$500-2000": score += 0.5
            case "$2000-5000": score += 0.75
            case "$5000+": score += 1.0
            default: break
            }
        }
        
        return min(score / 2.0, 1.0)
    }
}
