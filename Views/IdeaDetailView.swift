import SwiftUI

struct IdeaDetailView: View {
    let idea: BusinessIdea
    @Environment(\.dismiss) var dismiss
    @State private var isFavorited = false
    @State private var showActionSheet = false
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    // Hero Section
                    ZStack(alignment: .topLeading) {
                        LinearGradient(
                            gradient: Gradient(colors: [AppColors.primary, AppColors.accent]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(height: 200)
                        
                        VStack(alignment: .leading, spacing: AppSpacing.lg) {
                            HStack {
                                Button(action: { dismiss() }) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                                
                                Button(action: { isFavorited.toggle() }) {
                                    Image(systemName: isFavorited ? "heart.fill" : "heart")
                                        .font(.system(size: 18))
                                        .foregroundColor(.white)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                                Text(idea.category)
                                    .font(AppTypography.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Text(idea.title)
                                    .font(AppTypography.title1)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                        }
                        .padding(AppSpacing.lg)
                    }
                    
                    // Content
                    VStack(spacing: AppSpacing.lg) {
                        // Key Metrics
                        HStack(spacing: AppSpacing.lg) {
                            MetricCard(
                                icon: "dollarsign.circle",
                                title: "Budget",
                                value: idea.estimatedBudget
                            )
                            
                            MetricCard(
                                icon: "calendar",
                                title: "Timeline",
                                value: idea.timeToMarket
                            )
                            
                            let potentialColor = idea.marketPotential == "High" ? AppColors.success : (idea.marketPotential == "Medium" ? AppColors.warning : AppColors.primary)
                            MetricCard(
                                icon: "chart.line.uptrend.xyaxis",
                                title: "Potential",
                                value: idea.marketPotential,
                                color: potentialColor
                            )
                        }
                        .padding(AppSpacing.lg)
                        
                        // Description
                        VStack(alignment: .leading, spacing: AppSpacing.md) {
                            Text("Overview")
                                .font(AppTypography.headline)
                                .fontWeight(.semibold)
                            
                            Text(idea.details)
                                .font(AppTypography.body)
                                .foregroundColor(AppColors.text)
                                .lineSpacing(2)
                        }
                        .applyCardStyle()
                        
                        // Action Plan
                        VStack(alignment: .leading, spacing: AppSpacing.md) {
                            Text("Quick Start")
                                .font(AppTypography.headline)
                                .fontWeight(.semibold)
                            
                            VStack(spacing: AppSpacing.md) {
                                ActionStep(
                                    number: 1,
                                    title: "Research Market",
                                    description: "Validate demand and identify competitors"
                                )
                                
                                ActionStep(
                                    number: 2,
                                    title: "Develop MVP",
                                    description: "Build a minimum viable product"
                                )
                                
                                ActionStep(
                                    number: 3,
                                    title: "Get Feedback",
                                    description: "Test with early customers"
                                )
                                
                                ActionStep(
                                    number: 4,
                                    title: "Scale",
                                    description: "Refine and launch to broader market"
                                )
                            }
                        }
                        .applyCardStyle()
                        
                        // CTA Buttons
                        VStack(spacing: AppSpacing.md) {
                            Button(action: { }) {
                                HStack {
                                    Image(systemName: "checkmark.circle")
                                    Text("Start This Idea")
                                }
                                .applyButtonStyle()
                            }
                            
                            Button(action: { showActionSheet = true }) {
                                Text("View Details")
                                    .applySecondaryButtonStyle()
                            }
                        }
                        .padding(AppSpacing.lg)
                    }
                    
                    Spacer()
                        .frame(height: AppSpacing.xl)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Metric Card
struct MetricCard: View {
    let icon: String
    let title: String
    let value: String
    var color: Color = AppColors.primary
    
    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            VStack(spacing: AppSpacing.xs) {
                Text(value)
                    .font(AppTypography.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.text)
                
                Text(title)
                    .font(AppTypography.caption2)
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.md)
        .background(color.opacity(0.08))
        .cornerRadius(AppRadius.lg)
    }
}

// MARK: - Action Step
struct ActionStep: View {
    let number: Int
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            // Step Number
            ZStack {
                Circle()
                    .fill(AppColors.primary)
                    .frame(width: 32, height: 32)
                
                Text(String(number))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(title)
                    .font(AppTypography.headline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
        }
        .padding(AppSpacing.md)
        .background(AppColors.surface)
        .cornerRadius(AppRadius.lg)
    }
}

#Preview {
    IdeaDetailView(idea: BusinessIdea(
        id: "1",
        title: "AI Content Creator",
        description: "Generate content",
        category: "SaaS",
        marketPotential: "High",
        estimatedBudget: "$5k-$15k",
        timeToMarket: "3-6 months",
        details: "Details here"
    ))
}
