import SwiftUI

struct BusinessIdeasView: View {
    @StateObject private var viewModel = BusinessIdeasViewModel()
    @State private var selectedIdea: BusinessIdea?
    @State private var showDetailView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppSpacing.lg) {
                        // Header
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Your Ideas")
                                .font(AppTypography.largeTitle)
                                .fontWeight(.bold)
                            
                            Text("Personalized business ideas based on your profile")
                                .font(AppTypography.body)
                                .foregroundColor(AppColors.textSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(AppSpacing.lg)
                        
                        // Loading State
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(height: 200)
                                .frame(maxWidth: .infinity)
                                .applyCardStyle()
                                .padding(AppSpacing.lg)
                        }
                        
                        // Error State
                        if let error = viewModel.errorMessage {
                            VStack(spacing: AppSpacing.md) {
                                Image(systemName: "exclamationmark.triangle")
                                    .font(.system(size: 32))
                                    .foregroundColor(AppColors.danger)
                                
                                Text("Error Loading Ideas")
                                    .font(AppTypography.headline)
                                    .fontWeight(.semibold)
                                
                                Text(error)
                                    .font(AppTypography.body)
                                    .foregroundColor(AppColors.textSecondary)
                                    .multilineTextAlignment(.center)
                                
                                Button(action: { viewModel.loadIdeas() }) {
                                    Text("Try Again")
                                        .applyButtonStyle()
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .applyCardStyle()
                            .padding(AppSpacing.lg)
                        }
                        
                        // Ideas Grid
                        if !viewModel.ideas.isEmpty {
                            VStack(spacing: AppSpacing.lg) {
                                ForEach(viewModel.ideas) { idea in
                                    NavigationLink(destination: IdeaDetailView(idea: idea)) {
                                        IdeaCard(idea: idea)
                                    }
                                }
                            }
                            .padding(AppSpacing.lg)
                        }
                        
                        // Empty State
                        if viewModel.ideas.isEmpty && !viewModel.isLoading {
                            EmptyIdeasView(onRetry: { viewModel.loadIdeas() })
                                .padding(AppSpacing.xl)
                        }
                        
                        Spacer()
                            .frame(height: AppSpacing.xl)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .task {
            await viewModel.loadIdeas()
        }
    }
}

// MARK: - Idea Card
struct IdeaCard: View {
    let idea: BusinessIdea
    
    var potentialColor: Color {
        switch idea.marketPotential {
        case "High":
            return AppColors.success
        case "Medium":
            return AppColors.warning
        default:
            return AppColors.primary
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            // Icon and Badge
            HStack(spacing: AppSpacing.md) {
                ZStack {
                    Circle()
                        .fill(AppColors.primary.opacity(0.1))
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.primary)
                }
                
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(idea.title)
                        .font(AppTypography.headline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                    
                    Text(idea.category)
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                VStack(spacing: AppSpacing.xs) {
                    HStack(spacing: AppSpacing.xs) {
                        Circle()
                            .fill(potentialColor)
                            .frame(width: 6, height: 6)
                        
                        Text(idea.marketPotential)
                            .font(AppTypography.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(potentialColor)
                    }
                    .padding(.horizontal, AppSpacing.sm)
                    .padding(.vertical, AppSpacing.xs)
                    .background(potentialColor.opacity(0.1))
                    .cornerRadius(AppRadius.sm)
                }
            }
            
            // Description
            Text(idea.description)
                .font(AppTypography.body)
                .foregroundColor(AppColors.text)
                .lineLimit(2)
            
            Divider()
                .padding(.vertical, AppSpacing.sm)
            
            // Footer Stats
            HStack(spacing: AppSpacing.md) {
                HStack(spacing: AppSpacing.xs) {
                    Image(systemName: "dollarsign.circle")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.primary)
                    
                    Text(idea.estimatedBudget)
                        .font(AppTypography.caption2)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                HStack(spacing: AppSpacing.xs) {
                    Image(systemName: "calendar")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.primary)
                    
                    Text(idea.timeToMarket)
                        .font(AppTypography.caption2)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.primary)
            }
        }
        .applyCardStyle()
    }
}

// MARK: - Empty State
struct EmptyIdeasView: View {
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            Image(systemName: "sparkles")
                .font(.system(size: 48))
                .foregroundColor(AppColors.primary.opacity(0.3))
            
            VStack(spacing: AppSpacing.sm) {
                Text("No Ideas Yet")
                    .font(AppTypography.headline)
                    .fontWeight(.semibold)
                
                Text("Complete the assessment to get personalized business ideas")
                    .font(AppTypography.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: onRetry) {
                Text("Generate Ideas")
                    .applyButtonStyle()
            }
        }
        .frame(maxWidth: .infinity)
        .applyCardStyle()
    }
}

// MARK: - Business Ideas View Model
class BusinessIdeasViewModel: ObservableObject {
    @Published var ideas: [BusinessIdea] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func loadIdeas() {
        isLoading = true
        errorMessage = nil
        
        // Simulate loading from AI
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.ideas = [
                BusinessIdea(
                    id: "1",
                    title: "AI-Powered Content Creator",
                    description: "Generate high-quality content for small businesses using AI",
                    category: "SaaS",
                    marketPotential: "High",
                    estimatedBudget: "$5k-$15k",
                    timeToMarket: "3-6 months",
                    details: "A platform that uses AI to generate blog posts, social media content, and email newsletters tailored to each business's voice and audience."
                ),
                BusinessIdea(
                    id: "2",
                    title: "Virtual Event Platform",
                    description: "Host and manage virtual events with advanced engagement tools",
                    category: "B2B",
                    marketPotential: "High",
                    estimatedBudget: "$10k-$25k",
                    timeToMarket: "4-8 months",
                    details: "A comprehensive platform for hosting webinars, conferences, and networking events with interactive features, analytics, and monetization options."
                ),
                BusinessIdea(
                    id: "3",
                    title: "Micro-Learning App",
                    description: "Bite-sized educational content for professionals",
                    category: "EdTech",
                    marketPotential: "Medium",
                    estimatedBudget: "$8k-$20k",
                    timeToMarket: "2-4 months",
                    details: "An app delivering 5-10 minute courses on professional skills, ideal for busy professionals looking to upskill during commutes."
                )
            ]
            self.isLoading = false
        }
    }
}

struct BusinessIdea: Identifiable {
    let id: String
    let title: String
    let description: String
    let category: String
    let marketPotential: String
    let estimatedBudget: String
    let timeToMarket: String
    let details: String
}

#Preview {
    BusinessIdeasView()
}
