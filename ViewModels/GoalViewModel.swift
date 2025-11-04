import Foundation
import Combine

class GoalViewModel: ObservableObject {
    @Published var goals: [Goal] = []
    @Published var milestones: [Milestone] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    private let firebaseService = FirebaseService.shared
    
    func fetchGoals(userId: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let goals = try await firebaseService.fetchGoals(userId: userId)
            self.goals = goals.sorted { $0.dueDate < $1.dueDate }
        } catch {
            errorMessage = "Failed to fetch goals: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func addGoal(_ goal: Goal) async {
        do {
            try await firebaseService.saveGoal(goal)
            goals.append(goal)
        } catch {
            errorMessage = "Failed to add goal: \(error.localizedDescription)"
        }
    }
    
    func updateGoal(_ goal: Goal) async {
        do {
            try await firebaseService.updateGoal(goal)
            if let index = goals.firstIndex(where: { $0.id == goal.id }) {
                goals[index] = goal
            }
        } catch {
            errorMessage = "Failed to update goal: \(error.localizedDescription)"
        }
    }
    
    func fetchMilestones(ideaId: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let milestones = try await firebaseService.fetchMilestones(ideaId: ideaId)
            self.milestones = milestones.sorted { $0.startDate < $1.startDate }
        } catch {
            errorMessage = "Failed to fetch milestones: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func addMilestone(_ milestone: Milestone) async {
        do {
            try await firebaseService.saveMilestone(milestone)
            milestones.append(milestone)
        } catch {
            errorMessage = "Failed to add milestone: \(error.localizedDescription)"
        }
    }
    
    func updateMilestone(_ milestone: Milestone) async {
        do {
            try await firebaseService.updateMilestone(milestone)
            if let index = milestones.firstIndex(where: { $0.id == milestone.id }) {
                milestones[index] = milestone
            }
        } catch {
            errorMessage = "Failed to update milestone: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
