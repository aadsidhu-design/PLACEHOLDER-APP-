import SwiftUI

// MARK: - Progress Chart
struct ProgressChartView: View {
    let goals: [Goal]
    
    var completionStats: (completed: Int, total: Int) {
        let total = goals.count
        let completed = goals.filter { $0.status == .completed }.count
        return (completed, total)
    }
    
    var completionPercentage: Double {
        guard goals.count > 0 else { return 0 }
        return Double(completionStats.completed) / Double(completionStats.total) * 100
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Progress Overview")
                .font(.headline)
                .fontWeight(.semibold)
            
            // Circular Progress
            ZStack {
                Circle()
                    .fill(Color(.systemGray6))
                
                Circle()
                    .trim(from: 0, to: completionPercentage / 100)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .cyan]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.6), value: completionPercentage)
                
                VStack(spacing: 4) {
                    Text("\(Int(completionPercentage))%")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.blue)
                    
                    Text("\(completionStats.completed)/\(completionStats.total)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .frame(height: 150)
            
            // Stats Row
            HStack(spacing: 16) {
                VStack(spacing: 4) {
                    Text("Completed")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(completionStats.completed)")
                        .font(.headline)
                        .foregroundColor(.green)
                }
                Spacer()
                VStack(spacing: 4) {
                    Text("Remaining")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(completionStats.total - completionStats.completed)")
                        .font(.headline)
                        .foregroundColor(.orange)
                }
                Spacer()
                VStack(spacing: 4) {
                    Text("Total")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(completionStats.total)")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Priority Distribution Chart
struct PriorityDistributionChart: View {
    let goals: [Goal]
    
    var priorityStats: [(priority: GoalPriority, count: Int)] {
        let grouped = Dictionary(grouping: goals, by: { $0.priority })
        return [
            (GoalPriority.high, grouped[.high]?.count ?? 0),
            (GoalPriority.medium, grouped[.medium]?.count ?? 0),
            (GoalPriority.low, grouped[.low]?.count ?? 0)
        ]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Priority Distribution")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                ForEach(priorityStats, id: \.priority) { stat in
                    HStack(spacing: 12) {
                        Circle()
                            .fill(colorForPriority(stat.priority))
                            .frame(width: 12, height: 12)
                        
                        Text(stat.priority.rawValue.capitalized)
                            .font(.subheadline)
                        
                        Spacer()
                        
                        HStack(spacing: 8) {
                            // Bar
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color(.systemGray5))
                                    
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(colorForPriority(stat.priority))
                                        .frame(width: geo.size.width * CGFloat(stat.count) / CGFloat(max(priorityStats.map { $0.count }.max() ?? 1, 1)))
                                }
                            }
                            .frame(height: 20)
                            .frame(maxWidth: 80)
                            
                            Text("\(stat.count)")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .frame(width: 30, alignment: .trailing)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func colorForPriority(_ priority: GoalPriority) -> Color {
        switch priority {
        case .high:
            return .red
        case .medium:
            return .orange
        case .low:
            return .green
        }
    }
}

// MARK: - Status Overview
struct StatusOverviewView: View {
    let goals: [Goal]
    
    var statusStats: [(status: GoalStatus, count: Int)] {
        let grouped = Dictionary(grouping: goals, by: { $0.status })
        return [
            (GoalStatus.pending, grouped[.pending]?.count ?? 0),
            (GoalStatus.inProgress, grouped[.inProgress]?.count ?? 0),
            (GoalStatus.completed, grouped[.completed]?.count ?? 0)
        ]
    }
    
    var body: some View {
        HStack(spacing: 16) {
            ForEach(statusStats, id: \.status) { stat in
                VStack(spacing: 8) {
                    VStack(spacing: 4) {
                        Text(stat.status.displayName)
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text("\(stat.count)")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(colorForStatus(stat.status))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
            }
        }
        .padding()
    }
    
    private func colorForStatus(_ status: GoalStatus) -> Color {
        switch status {
        case .pending:
            return .gray
        case .inProgress:
            return .blue
        case .completed:
            return .green
        }
    }
}

extension GoalStatus {
    var displayName: String {
        switch self {
        case .pending:
            return "Pending"
        case .inProgress:
            return "In Progress"
        case .completed:
            return "Completed"
        }
    }
}
