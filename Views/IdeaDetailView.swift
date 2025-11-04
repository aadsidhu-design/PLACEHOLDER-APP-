import SwiftUI

struct IdeaDetailView: View {
    let idea: BusinessIdea
    @EnvironmentObject var goalViewModel: GoalViewModel
    @State private var showAddGoal = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Title and Summary
                VStack(alignment: .leading, spacing: 12) {
                    Text(idea.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(idea.summary)
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding()
                
                // Quick Stats
                HStack(spacing: 16) {
                    StatCard(label: "Timeline", value: "\(idea.roughTimelineWeeks)w")
                    StatCard(label: "Budget", value: idea.estimatedStartupCostRange)
                    StatCard(label: "Skills", value: "\(idea.requiredSkills.count)")
                }
                .padding()
                
                Divider()
                
                // Detailed Description
                VStack(alignment: .leading, spacing: 8) {
                    Text("About This Idea")
                        .font(.headline)
                    
                    Text(idea.detailedDescription)
                        .font(.body)
                        .foregroundColor(.gray)
                        .lineLimit(nil)
                }
                .padding()
                
                Divider()
                
                // Required Skills
                VStack(alignment: .leading, spacing: 8) {
                    Text("Required Skills")
                        .font(.headline)
                    
                    FlowLayout(items: idea.requiredSkills) { skill in
                        Text(skill)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(16)
                    }
                }
                .padding()
                
                Divider()
                
                // 30-Day Plan
                VStack(alignment: .leading, spacing: 8) {
                    Text("First 30 Days")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(idea.first30DayPlan.indices, id: \.self) { index in
                            HStack(spacing: 12) {
                                Text("\(index + 1)").fontWeight(.bold).foregroundColor(.blue)
                                Text(idea.first30DayPlan[index]).font(.body)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                .padding()
                
                Divider()
                
                // Revenue Model
                VStack(alignment: .leading, spacing: 8) {
                    Text("Revenue Model")
                        .font(.headline)
                    
                    Text(idea.revenueModelHint)
                        .font(.body)
                        .foregroundColor(.gray)
                        .lineLimit(nil)
                }
                .padding()
                
                // Start Button
                Button(action: { showAddGoal = true }) {
                    Text("Create Your Plan")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
        .navigationTitle("Business Idea")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StatCard: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct FlowLayout<T: Identifiable>: View where T: Hashable {
    let items: [T]
    let content: (T) -> AnyView
    
    var body: some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(items, id: \.self) { item in
                content(item)
                    .alignmentGuide(.leading) { d in
                        if abs(width - d.width) > 300 {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        width -= d.width
                        return result
                    }
                    .alignmentGuide(.top) { d in
                        let result = height
                        if abs(width) > 300 {
                            height -= d.height
                        }
                        return result
                    }
            }
        }
    }
}

extension FlowLayout where T == String {
    init(items: [String], @ViewBuilder content: @escaping (String) -> some View) {
        self.items = items.enumerated().map { ($0.offset, $0.element) }
        self.content = { item in
            AnyView(content(item.1))
        }
    }
}

#Preview {
    IdeaDetailView(
        idea: BusinessIdea(
            id: "1",
            userId: "user1",
            title: "SaaS Product",
            summary: "A software-as-a-service product for small businesses",
            detailedDescription: "This is a detailed description...",
            requiredSkills: ["Software Development", "Product Design"],
            roughTimelineWeeks: 12,
            first30DayPlan: ["Validate idea", "Create prototype"],
            revenueModelHint: "Monthly subscription",
            estimatedStartupCostRange: "$2000-5000",
            aiPromptUsed: nil,
            tags: ["SaaS", "Tech"],
            createdAt: Date()
        )
    )
    .environmentObject(GoalViewModel())
}
