import SwiftUI

@main
struct BusinessIdeaApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var ideaViewModel = IdeaViewModel()
    @StateObject private var quizViewModel = QuizViewModel()
    @StateObject private var goalViewModel = GoalViewModel()
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                ContentView()
                    .environmentObject(authViewModel)
                    .environmentObject(ideaViewModel)
                    .environmentObject(quizViewModel)
                    .environmentObject(goalViewModel)
            } else {
                LandingPageView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
