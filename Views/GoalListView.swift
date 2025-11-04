import SwiftUI

struct GoalListView: View {
    @StateObject private var viewModel = GoalViewModel()
    @State private var showAddGoalSheet = false
    @State private var selectedFilter: GoalFilterType = .all
    
    var filteredGoals: [Goal] {
        switch selectedFilter {
        case .all:
            return viewModel.goals
        case .pending:
            return viewModel.goals.filter { $0.status == .pending }
        case .inProgress:
            return viewModel.goals.filter { $0.status == .inProgress }
        case .completed:
            return viewModel.goals.filter { $0.status == .completed }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppSpacing.lg) {
                        // Header
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("My Goals")
                                .font(AppTypography.largeTitle)
                                .fontWeight(.bold)
                            
                            Text("\(viewModel.goals.count) goals • \(viewModel.goals.filter { $0.status == .completed }.count) completed")
                                .font(AppTypography.caption)
                                .foregroundColor(AppColors.textSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(AppSpacing.lg)
                        
                        // Charts Section
                        if !viewModel.goals.isEmpty {
                            ChartsSection(goals: viewModel.goals)
                                .padding(AppSpacing.lg)
                        }
                        
                        // Filter Buttons
                        FilterSegmentedControl(selectedFilter: $selectedFilter)
                            .padding(.horizontal, AppSpacing.lg)
                        
                        // Goals List
                        if filteredGoals.isEmpty {
                            EmptyGoalsView()
                                .padding(AppSpacing.xl)
                        } else {
                            VStack(spacing: AppSpacing.md) {
                                ForEach(filteredGoals) { goal in
                                    GoalCard(goal: goal, onTap: {
                                        // Handle goal tap
                                    })
                                }
                            }
                            .padding(AppSpacing.lg)
                        }
                        
                        Spacer()
                            .frame(height: AppSpacing.xl)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showAddGoalSheet = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(AppColors.primary)
                        }
                    }
                }
                .sheet(isPresented: $showAddGoalSheet) {
                    AddGoalSheet(isPresented: $showAddGoalSheet, onAdd: { goal in
                        viewModel.addGoal(goal)
                    })
                }
            }
        }
        .task {
            await viewModel.loadGoals()
        }
    }
}

// MARK: - Charts Section
struct ChartsSection: View {
    let goals: [Goal]
    @State private var selectedChartTab = 0
    
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            // Tab Selector
            Picker("Chart Type", selection: $selectedChartTab) {
                Text("Progress").tag(0)
                Text("Priority").tag(1)
                Text("Status").tag(2)
            }
            .pickerStyle(.segmented)
            .padding(AppSpacing.md)
            .background(AppColors.surface)
            .cornerRadius(AppRadius.lg)
            
            // Chart Content
            Group {
                if selectedChartTab == 0 {
                    ProgressChartView(goals: goals)
                } else if selectedChartTab == 1 {
                    PriorityDistributionChart(goals: goals)
                } else {
                    StatusOverviewView(goals: goals)
                }
            }
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.3), value: selectedChartTab)
        }
        .applyCardStyle()
    }
}

// MARK: - Filter Segmented Control
struct FilterSegmentedControl: View {
    @Binding var selectedFilter: GoalFilterType
    
    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            ForEach(GoalFilterType.allCases, id: \.self) { filter in
                Button(action: { selectedFilter = filter }) {
                    Text(filter.rawValue.capitalized)
                        .font(AppTypography.caption)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppSpacing.sm)
                        .background(selectedFilter == filter ? AppColors.primary : AppColors.surface)
                        .foregroundColor(selectedFilter == filter ? .white : AppColors.text)
                        .cornerRadius(AppRadius.md)
                }
            }
        }
        .padding(AppSpacing.sm)
        .background(AppColors.surface)
        .cornerRadius(AppRadius.lg)
    }
}

enum GoalFilterType: String, CaseIterable {
    case all = "all"
    case pending = "pending"
    case inProgress = "in progress"
    case completed = "completed"
}

// MARK: - Goal Card
struct GoalCard: View {
    let goal: Goal
    let onTap: () -> Void
    
    var statusColor: Color {
        switch goal.status {
        case .pending:
            return AppColors.warning
        case .inProgress:
            return AppColors.primary
        case .completed:
            return AppColors.success
        }
    }
    
    var priorityColor: Color {
        switch goal.priority {
        case .high:
            return AppColors.danger
        case .medium:
            return AppColors.warning
        case .low:
            return AppColors.success
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                // Header with Priority Badge
                HStack(spacing: AppSpacing.md) {
                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        Text(goal.title)
                            .font(AppTypography.headline)
                            .fontWeight(.semibold)
                            .lineLimit(2)
                            .foregroundColor(AppColors.text)
                        
                        if !goal.description.isEmpty {
                            Text(goal.description)
                                .font(AppTypography.caption)
                                .foregroundColor(AppColors.textSecondary)
                                .lineLimit(1)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(spacing: AppSpacing.xs) {
                        // Priority Badge
                        HStack(spacing: AppSpacing.xs) {
                            Circle()
                                .fill(priorityColor)
                                .frame(width: 8, height: 8)
                            
                            Text(goal.priority.rawValue.capitalized)
                                .font(AppTypography.caption2)
                                .fontWeight(.semibold)
                                .foregroundColor(priorityColor)
                        }
                        .padding(.horizontal, AppSpacing.sm)
                        .padding(.vertical, AppSpacing.xs)
                        .background(priorityColor.opacity(0.1))
                        .cornerRadius(AppRadius.sm)
                    }
                }
                
                // Status and Progress
                HStack(spacing: AppSpacing.md) {
                    // Status Indicator
                    HStack(spacing: AppSpacing.xs) {
                        Image(systemName: statusIcon(for: goal.status))
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(statusColor)
                        
                        Text(goal.status.displayName)
                            .font(AppTypography.caption)
                            .foregroundColor(statusColor)
                    }
                    
                    Spacer()
                    
                    // Due Date
                    if let dueDate = goal.dueDate {
                        HStack(spacing: AppSpacing.xs) {
                            Image(systemName: "calendar")
                                .font(.system(size: 14))
                            
                            Text(dueDate.formatted(date: .abbreviated, time: .omitted))
                                .font(AppTypography.caption)
                        }
                        .foregroundColor(AppColors.textSecondary)
                    }
                }
                
                // Progress Bar
                if goal.milestones.count > 0 {
                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        HStack {
                            Text("Progress")
                                .font(AppTypography.caption2)
                                .foregroundColor(AppColors.textSecondary)
                            
                            Spacer()
                            
                            let completed = goal.milestones.filter { $0.isCompleted }.count
                            Text("\(completed)/\(goal.milestones.count)")
                                .font(AppTypography.caption2)
                                .fontWeight(.semibold)
                                .foregroundColor(AppColors.primary)
                        }
                        
                        ProgressView(
                            value: Double(goal.milestones.filter { $0.isCompleted }.count),
                            total: Double(goal.milestones.count)
                        )
                        .tint(AppColors.primary)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .applyCardStyle()
        }
    }
    
    private func statusIcon(for status: GoalStatus) -> String {
        switch status {
        case .pending:
            return "circle"
        case .inProgress:
            return "play.circle.fill"
        case .completed:
            return "checkmark.circle.fill"
        }
    }
}

// MARK: - Empty State
struct EmptyGoalsView: View {
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 48))
                .foregroundColor(AppColors.primary.opacity(0.3))
            
            VStack(spacing: AppSpacing.sm) {
                Text("No Goals Yet")
                    .font(AppTypography.headline)
                    .fontWeight(.semibold)
                
                Text("Start by creating your first goal to track your progress")
                    .font(AppTypography.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(AppSpacing.xl)
        .frame(maxWidth: .infinity)
        .applyCardStyle()
    }
}

// MARK: - Add Goal Sheet
struct AddGoalSheet: View {
    @Binding var isPresented: Bool
    let onAdd: (Goal) -> Void
    
    @State private var title = ""
    @State private var description = ""
    @State private var priority: GoalPriority = .medium
    @State private var dueDate: Date = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    
    var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Goal Details")) {
                    TextField("Goal Title", text: $title)
                    
                    TextField("Description (Optional)", text: $description, axis: .vertical)
                        .lineLimit(3...)
                }
                
                Section(header: Text("Priority")) {
                    Picker("Priority", selection: $priority) {
                        ForEach(GoalPriority.allCases, id: \.self) { p in
                            Text(p.rawValue.capitalized).tag(p)
                        }
                    }
                }
                
                Section(header: Text("Due Date")) {
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                }
            }
            .navigationTitle("New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        let newGoal = Goal(
                            id: UUID().uuidString,
                            title: title,
                            description: description,
                            priority: priority,
                            status: .pending,
                            dueDate: dueDate,
                            milestones: []
                        )
                        onAdd(newGoal)
                        isPresented = false
                    }) {
                        Text("Add")
                            .fontWeight(.semibold)
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
}

// MARK: - Goal View Model
class GoalViewModel: ObservableObject {
    @Published var goals: [Goal] = []
    
    func loadGoals() async {
        // Load from Firestore or local storage
        // For now, load sample data
        goals = [
            Goal(
                id: "1",
                title: "Launch E-commerce Store",
                description: "Set up and launch online store",
                priority: .high,
                status: .inProgress,
                dueDate: Date().addingTimeInterval(30 * 24 * 3600),
                milestones: [
                    Milestone(id: "1", title: "Design Store", isCompleted: true),
                    Milestone(id: "2", title: "Set up Payment", isCompleted: true),
                    Milestone(id: "3", title: "Add Products", isCompleted: false)
                ]
            ),
            Goal(
                id: "2",
                title: "Reach 1000 Followers",
                description: "Grow social media presence",
                priority: .medium,
                status: .inProgress,
                dueDate: Date().addingTimeInterval(60 * 24 * 3600),
                milestones: []
            ),
            Goal(
                id: "3",
                title: "Complete Business Plan",
                description: "Finalize detailed business plan",
                priority: .high,
                status: .completed,
                dueDate: Date().addingTimeInterval(-7 * 24 * 3600),
                milestones: []
            ),
            Goal(
                id: "4",
                title: "Build MVP",
                description: "Create minimum viable product",
                priority: .low,
                status: .pending,
                dueDate: Date().addingTimeInterval(90 * 24 * 3600),
                milestones: []
            )
        ]
    }
    
    func addGoal(_ goal: Goal) {
        goals.append(goal)
    }
    
    func updateGoal(_ goal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index] = goal
        }
    }
    
    func deleteGoal(_ goalId: String) {
        goals.removeAll { $0.id == goalId }
    }
}

#Preview {
    GoalListView()
}
