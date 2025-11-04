import Foundation
import Combine

class IdeaViewModel: ObservableObject {
    @Published var businessIdeas: [BusinessIdea] = []
    @Published var selectedIdea: BusinessIdea? = nil
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var ideasGenerated = false
    
    private let firebaseService = FirebaseService.shared
    private let googleAIService = GoogleAIService.shared
    
    func generateIdeas(from quizResponse: QuizResponse, userProfile: User) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let ideas = try await googleAIService.generateBusinessIdeas(from: quizResponse, userProfile: userProfile)
            
            // Save ideas to Firebase
            for idea in ideas {
                try await firebaseService.saveBusinessIdea(idea)
            }
            
            self.businessIdeas = ideas
            self.ideasGenerated = true
        } catch {
            errorMessage = "Failed to generate ideas: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func fetchIdeas(userId: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let ideas = try await firebaseService.fetchBusinessIdeas(userId: userId)
            self.businessIdeas = ideas
        } catch {
            errorMessage = "Failed to fetch ideas: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func toggleFavorite(for idea: BusinessIdea) async {
        var updatedIdea = idea
        updatedIdea.isFavorite.toggle()
        
        do {
            try await firebaseService.updateBusinessIdea(updatedIdea)
            if let index = businessIdeas.firstIndex(where: { $0.id == idea.id }) {
                businessIdeas[index] = updatedIdea
            }
        } catch {
            errorMessage = "Failed to update favorite: \(error.localizedDescription)"
        }
    }
}
