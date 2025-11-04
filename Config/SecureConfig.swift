import Foundation

/// Secure configuration loader for sensitive API keys and Firebase credentials
struct SecureConfig {
    /// Load Google AI API key from Info.plist (injected at build time)
    /// This is set via Xcode build settings or environment variables during CI/CD
    static var googleAIKey: String {
        guard let key = Bundle.main.infoDictionary?["GOOGLE_AI_API_KEY"] as? String,
              !key.isEmpty,
              !key.contains("$(GOOGLE_AI_API_KEY)") else {
            // Fallback: Try environment variable (for local development)
            return ProcessInfo.processInfo.environment["GOOGLE_AI_API_KEY"] ?? ""
        }
        return key
    }
    
    /// Firebase Project ID (safe to include in app)
    static let firebaseProjectID: String = {
        Bundle.main.infoDictionary?["FIREBASE_PROJECT_ID"] as? String ?? "studio-5837146656-10acf"
    }()
    
    /// Firebase Project Number (safe to include in app)
    static let firebaseProjectNumber: String = {
        Bundle.main.infoDictionary?["FIREBASE_PROJECT_NUMBER"] as? String ?? "1095936176351"
    }()
    
    /// App name
    static let appName: String = {
        Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "BusinessIdea"
    }()
    
    /// App version
    static let appVersion: String = {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }()
    
    /// Validate that all required keys are loaded
    static func validateConfiguration() -> Bool {
        let hasGoogleAI = !googleAIKey.isEmpty && !googleAIKey.contains("$(")
        let hasFirebase = !firebaseProjectID.isEmpty
        
        if !hasGoogleAI {
            print("⚠️ Warning: Google AI API key not configured")
        }
        if !hasFirebase {
            print("⚠️ Warning: Firebase configuration incomplete")
        }
        
        return hasGoogleAI && hasFirebase
    }
}
