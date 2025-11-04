import SwiftUI

struct LandingPageView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Hero Section
                    VStack(spacing: AppSpacing.lg) {
                        VStack(spacing: AppSpacing.lg) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [AppColors.primary, AppColors.accent]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "lightbulb.max.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(spacing: AppSpacing.md) {
                                Text("Find Your Perfect")
                                    .font(AppTypography.largeTitle)
                                    .fontWeight(.bold)
                                + Text(" Business")
                                    .font(AppTypography.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(AppColors.primary)
                                
                                Text("Personalized business ideas powered by AI")
                                    .font(AppTypography.body)
                                    .foregroundColor(AppColors.textSecondary)
                            }
                            .multilineTextAlignment(.center)
                        }
                        .padding(AppSpacing.xl)
                    }
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                AppColors.primary.opacity(0.05),
                                AppColors.accent.opacity(0.05)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    
                    // Features Section
                    VStack(spacing: AppSpacing.lg) {
                        Text("Why Choose Us?")
                            .font(AppTypography.title2)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: AppSpacing.lg) {
                            FeatureCard(
                                icon: "questionmark.circle",
                                title: "Smart Quiz",
                                description: "Quick assessment of your skills"
                            )
                            
                            FeatureCard(
                                icon: "sparkles",
                                title: "AI-Powered",
                                description: "Personalized ideas instantly"
                            )
                            
                            FeatureCard(
                                icon: "chart.line.uptrend.xyaxis",
                                title: "Track Progress",
                                description: "Monitor goals seamlessly"
                            )
                            
                            FeatureCard(
                                icon: "checkmark.circle",
                                title: "Action Plans",
                                description: "30-day plans to start"
                            )
                        }
                    }
                    .padding(AppSpacing.xl)
                    
                    // CTA Section
                    VStack(spacing: AppSpacing.md) {
                        NavigationLink(destination: SignUpView()) {
                            HStack {
                                Text("Get Started")
                                Image(systemName: "arrow.right")
                            }
                            .applyButtonStyle()
                        }
                        
                        NavigationLink(destination: SignInView()) {
                            Text("Already have an account? Sign In")
                                .applySecondaryButtonStyle()
                        }
                    }
                    .padding(AppSpacing.xl)
                }
            }
            .background(AppColors.background)
            .navigationBarHidden(true)
        }
    }
}

struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: AppSpacing.lg) {
            ZStack {
                Circle()
                    .fill(AppColors.primary.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(AppColors.primary)
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
        .applyCardStyle()
    }
}

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var agreedToTerms = false
    
    var isFormValid: Bool {
        !authViewModel.displayName.isEmpty &&
        !authViewModel.email.isEmpty &&
        !authViewModel.password.isEmpty &&
        agreedToTerms
    }
    
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Create Account")
                    .font(AppTypography.title2)
                    .fontWeight(.bold)
                
                Text("Start your journey")
                    .font(AppTypography.body)
                    .foregroundColor(AppColors.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(AppSpacing.lg)
            
            VStack(spacing: AppSpacing.md) {
                ModernTextField(
                    placeholder: "Full Name",
                    text: $authViewModel.displayName,
                    icon: "person"
                )
                
                ModernTextField(
                    placeholder: "Email",
                    text: $authViewModel.email,
                    icon: "envelope",
                    keyboardType: .emailAddress
                )
                
                ModernSecureField(
                    placeholder: "Password",
                    text: $authViewModel.password,
                    icon: "lock"
                )
                
                HStack(spacing: AppSpacing.sm) {
                    Image(systemName: agreedToTerms ? "checkmark.square.fill" : "square")
                        .foregroundColor(agreedToTerms ? AppColors.primary : AppColors.border)
                        .onTapGesture { agreedToTerms.toggle() }
                    
                    Text("I agree to Terms")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textSecondary)
                    Spacer()
                }
                .padding(AppSpacing.md)
                .background(AppColors.surface)
                .cornerRadius(AppRadius.lg)
            }
            .padding(AppSpacing.lg)
            
            if let error = authViewModel.errorMessage {
                Text(error)
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.danger)
                    .padding(AppSpacing.md)
                    .frame(maxWidth: .infinity)
                    .background(AppColors.danger.opacity(0.1))
                    .cornerRadius(AppRadius.lg)
                    .padding(.horizontal, AppSpacing.lg)
            }
            
            Button(action: {
                Task { await authViewModel.signUp() }
            }) {
                if authViewModel.isLoading {
                    ProgressView().frame(maxWidth: .infinity)
                } else {
                    Text("Create Account")
                }
            }
            .applyButtonStyle()
            .disabled(authViewModel.isLoading || !isFormValid)
            .padding(AppSpacing.lg)
            
            Spacer()
        }
        .background(AppColors.background)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SignInView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var isFormValid: Bool {
        !authViewModel.email.isEmpty &&
        !authViewModel.password.isEmpty
    }
    
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Welcome Back")
                    .font(AppTypography.title2)
                    .fontWeight(.bold)
                
                Text("Continue your journey")
                    .font(AppTypography.body)
                    .foregroundColor(AppColors.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(AppSpacing.lg)
            
            VStack(spacing: AppSpacing.md) {
                ModernTextField(
                    placeholder: "Email",
                    text: $authViewModel.email,
                    icon: "envelope",
                    keyboardType: .emailAddress
                )
                
                ModernSecureField(
                    placeholder: "Password",
                    text: $authViewModel.password,
                    icon: "lock"
                )
            }
            .padding(AppSpacing.lg)
            
            if let error = authViewModel.errorMessage {
                Text(error)
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.danger)
                    .padding(AppSpacing.md)
                    .frame(maxWidth: .infinity)
                    .background(AppColors.danger.opacity(0.1))
                    .cornerRadius(AppRadius.lg)
                    .padding(.horizontal, AppSpacing.lg)
            }
            
            Button(action: {
                Task { await authViewModel.signIn() }
            }) {
                if authViewModel.isLoading {
                    ProgressView().frame(maxWidth: .infinity)
                } else {
                    Text("Sign In")
                }
            }
            .applyButtonStyle()
            .disabled(authViewModel.isLoading || !isFormValid)
            .padding(AppSpacing.lg)
            
            Spacer()
        }
        .background(AppColors.background)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ModernTextField: View {
    let placeholder: String
    @Binding var text: String
    let icon: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: icon)
                .foregroundColor(AppColors.primary)
                .frame(width: 20)
            
            TextField(placeholder, text: $text)
                .font(AppTypography.body)
                .keyboardType(keyboardType)
                .autocapitalization(.none)
        }
        .padding(AppSpacing.md)
        .background(AppColors.surface)
        .cornerRadius(AppRadius.lg)
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .stroke(AppColors.border, lineWidth: 1)
        )
    }
}

struct ModernSecureField: View {
    let placeholder: String
    @Binding var text: String
    let icon: String
    @State private var isSecureFieldVisible = false
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: icon)
                .foregroundColor(AppColors.primary)
                .frame(width: 20)
            
            if isSecureFieldVisible {
                TextField(placeholder, text: $text)
                    .font(AppTypography.body)
                    .autocapitalization(.none)
            } else {
                SecureField(placeholder, text: $text)
                    .font(AppTypography.body)
            }
            
            Button(action: { isSecureFieldVisible.toggle() }) {
                Image(systemName: isSecureFieldVisible ? "eye.slash" : "eye")
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.surface)
        .cornerRadius(AppRadius.lg)
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .stroke(AppColors.border, lineWidth: 1)
        )
    }
}

#Preview {
    LandingPageView()
        .environmentObject(AuthViewModel())
}
