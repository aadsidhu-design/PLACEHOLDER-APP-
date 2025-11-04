import SwiftUI

struct GoalListView: View {
    @EnvironmentObject var goalViewModel: GoalViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showAddGoal = false
    
    var body: some View {
        VStack {
            if goalViewModel.isLoading {
                ProgressView()
                    .task {
                        await goalViewModel.fetchGoals(userId: authViewModel.firebaseService.currentUser?.id ?? "")
                    }
            } else if goalViewModel.goals.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("No goals yet")
                        .font(.headline)
                    
                    Text("Create goals from your business idea")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
            } else {
                List {
                    ForEach(goalViewModel.goals) { goal in
                        GoalRowView(goal: goal, onUpdate: { updatedGoal in
                            Task {
                                await goalViewModel.updateGoal(updatedGoal)
                            }
                        })
                    }
                }
            }
        }
        .navigationTitle("Goals")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showAddGoal = true }) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct GoalRowView: View {
    let goal: Goal
    var onUpdate: (Goal) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.title)
                        .font(.headline)
                    
                    Text(goal.dueDate, style: .date)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: {
                    var updatedGoal = goal
                    updatedGoal.status = updatedGoal.status == .completed ? .pending : .completed
                    if updatedGoal.status == .completed {
                        updatedGoal.completedAt = Date()
                    }
                    onUpdate(updatedGoal)
                }) {
                    Image(systemName: goal.status == .completed ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(goal.status == .completed ? .green : .gray)
                }
            }
            
            if let description = goal.description {
                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
        .opacity(goal.status == .completed ? 0.6 : 1.0)
    }
}

struct TimelineView: View {
    @EnvironmentObject var goalViewModel: GoalViewModel
    let idea: BusinessIdea
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Timeline")
                .font(.headline)
            
            if goalViewModel.milestones.isEmpty {
                Text("No milestones yet")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(goalViewModel.milestones) { milestone in
                            MilestoneRowView(milestone: milestone)
                        }
                    }
                    .padding()
                }
            }
        }
        .padding()
    }
}

struct MilestoneRowView: View {
    let milestone: Milestone
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .center, spacing: 0) {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 12, height: 12)
                
                Rectangle()
                    .fill(Color.blue.opacity(0.3))
                    .frame(width: 2)
                    .frame(height: 40)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(milestone.title)
                    .font(.headline)
                
                HStack(spacing: 16) {
                    Text(milestone.startDate, style: .date)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    ProgressView(value: milestone.progress)
                        .frame(maxWidth: 60)
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    GoalListView()
        .environmentObject(GoalViewModel())
        .environmentObject(AuthViewModel())
}
