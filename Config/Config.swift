import Foundation

// MARK: - Configuration
// Store sensitive credentials in environment variables or Xcode build settings
// DO NOT commit API keys to the repository

struct Config {
    /// Google AI API Key - set via environment variable or build settings
    /// To use: set GOOGLE_AI_API_KEY in scheme or as environment variable
    static let googleAIKey: String = {
        ProcessInfo.processInfo.environment["GOOGLE_AI_API_KEY"] ?? ""
    }()
    
    /// Firebase Project Configuration
    static let firebaseProjectID = "studio-5837146656-10acf"
    static let firebaseProjectNumber = "1095936176351"
    static let firebaseWebAPIKey = "AIzaSyD0yDZFbfJd68FOL2jPVbopg8UEUOd3tXQ"
    
    /// App Settings
    static let appName = "BusinessIdea"
    static let appVersion = "1.0.0"
    static let minimumIOSVersion = "14.0"
}
