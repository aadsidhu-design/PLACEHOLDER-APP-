import SwiftUI

// MARK: - App Colors
struct AppColors {
    // Primary
    static let primary = Color(red: 0.0, green: 0.48, blue: 1.0) // iOS Blue
    static let primaryLight = Color(red: 0.5, green: 0.85, blue: 1.0)
    
    // Accents
    static let accent = Color(red: 0.0, green: 0.95, blue: 1.0) // Cyan
    static let success = Color(red: 0.2, green: 0.78, blue: 0.35) // Green
    static let warning = Color(red: 1.0, green: 0.58, blue: 0.0) // Orange
    static let danger = Color(red: 1.0, green: 0.23, blue: 0.19) // Red
    
    // Neutrals
    static let text = Color(UIColor.label)
    static let textSecondary = Color(UIColor.secondaryLabel)
    static let background = Color(UIColor.systemBackground)
    static let surface = Color(UIColor.secondarySystemBackground)
    static let border = Color(UIColor.separator)
}

// MARK: - Typography
struct AppTypography {
    static let largeTitle = Font.system(size: 34, weight: .bold, design: .default)
    static let title1 = Font.system(size: 28, weight: .bold, design: .default)
    static let title2 = Font.system(size: 22, weight: .bold, design: .default)
    static let title3 = Font.system(size: 20, weight: .semibold, design: .default)
    static let headline = Font.system(size: 17, weight: .semibold, design: .default)
    static let body = Font.system(size: 17, weight: .regular, design: .default)
    static let caption = Font.system(size: 12, weight: .regular, design: .default)
    static let caption2 = Font.system(size: 11, weight: .regular, design: .default)
}

// MARK: - Spacing
struct AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
}

// MARK: - Shadows
struct AppShadows {
    static let sm = Shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    static let md = Shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
    static let lg = Shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
    static let xl = Shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 6)
}

struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - Border Radius
struct AppRadius {
    static let sm: CGFloat = 4
    static let md: CGFloat = 8
    static let lg: CGFloat = 12
    static let xl: CGFloat = 16
    static let round: CGFloat = 32
}

// MARK: - View Modifiers
extension View {
    func applyCardStyle() -> some View {
        self
            .padding(AppSpacing.lg)
            .background(AppColors.surface)
            .cornerRadius(AppRadius.lg)
            .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
    
    func applyButtonStyle(_ color: Color = AppColors.primary) -> some View {
        self
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(AppRadius.lg)
            .font(AppTypography.headline)
            .fontWeight(.semibold)
    }
    
    func applySecondaryButtonStyle() -> some View {
        self
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .background(AppColors.surface)
            .foregroundColor(AppColors.primary)
            .cornerRadius(AppRadius.lg)
            .font(AppTypography.headline)
            .fontWeight(.semibold)
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .stroke(AppColors.border, lineWidth: 1)
            )
    }
}
