import SwiftUI

struct SubscriptionPaywallView: View {
    @State private var selectedPlan: SubscriptionPlan = .pro
    @State private var isProcessing = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppSpacing.lg) {
                        // Header
                        VStack(alignment: .center, spacing: AppSpacing.md) {
                            Text("Unlock Premium")
                                .font(AppTypography.largeTitle)
                                .fontWeight(.bold)
                            
                            Text("Get unlimited access to all features")
                                .font(AppTypography.body)
                                .foregroundColor(AppColors.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(AppSpacing.lg)
                        
                        // Features List
                        VStack(spacing: AppSpacing.md) {
                            FeatureRow(icon: "sparkles", text: "Unlimited AI Ideas")
                            FeatureRow(icon: "chart.line.uptrend.xyaxis", text: "Advanced Analytics")
                            FeatureRow(icon: "bell.fill", text: "Priority Notifications")
                            FeatureRow(icon: "cloud.fill", text: "Cloud Sync")
                            FeatureRow(icon: "checkmark.circle.fill", text: "Export Plans")
                        }
                        .padding(AppSpacing.lg)
                        
                        Divider()
                            .padding(.horizontal, AppSpacing.lg)
                        
                        // Plans
                        VStack(spacing: AppSpacing.lg) {
                            Text("Choose Your Plan")
                                .font(AppTypography.headline)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            ForEach([SubscriptionPlan.monthly, SubscriptionPlan.yearly], id: \.self) { plan in
                                PlanCard(
                                    plan: plan,
                                    isSelected: selectedPlan == plan,
                                    onSelect: { selectedPlan = plan }
                                )
                            }
                        }
                        .padding(AppSpacing.lg)
                        
                        // CTA
                        VStack(spacing: AppSpacing.md) {
                            Button(action: { isProcessing = true }) {
                                if isProcessing {
                                    ProgressView()
                                        .frame(maxWidth: .infinity)
                                } else {
                                    Text("Subscribe Now")
                                        .applyButtonStyle()
                                }
                            }
                            .disabled(isProcessing)
                            
                            Button(action: { dismiss() }) {
                                Text("Continue Free")
                                    .applySecondaryButtonStyle()
                            }
                        }
                        .padding(AppSpacing.lg)
                        
                        // Legal
                        VStack(spacing: AppSpacing.sm) {
                            Text("7-day free trial, then \(selectedPlan.price)/\(selectedPlan.period)")
                                .font(AppTypography.caption2)
                                .foregroundColor(AppColors.textSecondary)
                            
                            HStack(spacing: AppSpacing.md) {
                                Button(action: { }) {
                                    Text("Terms")
                                        .font(AppTypography.caption2)
                                        .foregroundColor(AppColors.primary)
                                }
                                
                                Divider()
                                    .frame(height: 12)
                                
                                Button(action: { }) {
                                    Text("Privacy")
                                        .font(AppTypography.caption2)
                                        .foregroundColor(AppColors.primary)
                                }
                            }
                        }
                        .multilineTextAlignment(.center)
                        .padding(AppSpacing.lg)
                        
                        Spacer()
                            .frame(height: AppSpacing.xl)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(AppColors.textSecondary)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Feature Row
struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(AppColors.primary)
                .frame(width: 24)
            
            Text(text)
                .font(AppTypography.body)
                .foregroundColor(AppColors.text)
            
            Spacer()
        }
    }
}

// MARK: - Plan Card
struct PlanCard: View {
    let plan: SubscriptionPlan
    let isSelected: Bool
    let onSelect: () -> Void
    
    var savingsPercentage: Int? {
        if case .yearly = plan {
            return 20 // Example: 20% savings
        }
        return nil
    }
    
    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                HStack {
                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        Text(plan.name)
                            .font(AppTypography.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(AppColors.text)
                        
                        HStack(spacing: AppSpacing.sm) {
                            Text(plan.price)
                                .font(AppTypography.title2)
                                .fontWeight(.bold)
                                .foregroundColor(AppColors.primary)
                            
                            Text("/\(plan.period)")
                                .font(AppTypography.caption)
                                .foregroundColor(AppColors.textSecondary)
                        }
                    }
                    
                    Spacer()
                    
                    if let savings = savingsPercentage {
                        VStack(spacing: AppSpacing.xs) {
                            Text("Save \(savings)%")
                                .font(AppTypography.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .padding(AppSpacing.sm)
                        .background(AppColors.success)
                        .cornerRadius(AppRadius.sm)
                    }
                    
                    ZStack {
                        Circle()
                            .stroke(isSelected ? AppColors.primary : AppColors.border, lineWidth: 2)
                            .frame(width: 24, height: 24)
                        
                        if isSelected {
                            Circle()
                                .fill(AppColors.primary)
                                .frame(width: 8, height: 8)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(AppSpacing.lg)
            .background(isSelected ? AppColors.primary.opacity(0.08) : AppColors.surface)
            .cornerRadius(AppRadius.lg)
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .stroke(isSelected ? AppColors.primary : AppColors.border, lineWidth: 1)
            )
        }
    }
}

// MARK: - Data Models
enum SubscriptionPlan: String, CaseIterable, Identifiable, Equatable {
    case pro = "Pro"
    case yearly = "Yearly"
    
    var id: String { self.rawValue }
    
    var name: String {
        switch self {
        case .pro:
            return "Monthly"
        case .yearly:
            return "Yearly"
        }
    }
    
    var price: String {
        switch self {
        case .pro:
            return "$9.99"
        case .yearly:
            return "$79.99"
        }
    }
    
    var period: String {
        switch self {
        case .pro:
            return "month"
        case .yearly:
            return "year"
        }
    }
}

#Preview {
    SubscriptionPaywallView()
}
