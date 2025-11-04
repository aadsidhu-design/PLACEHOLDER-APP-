import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var selectedTab = 0
    @State private var showSubscriptionPaywall = false
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            if authViewModel.isAuthenticated {
                // Main App Tabs
                TabView(selection: $selectedTab) {
                    // Ideas Tab
                    NavigationView {
                        BusinessIdeasView()
                    }
                    .tabItem {
                        Label("Ideas", systemImage: "sparkles")
                    }
                    .tag(0)
                    
                    // Goals Tab
                    NavigationView {
                        GoalListView()
                    }
                    .tabItem {
                        Label("Goals", systemImage: "checkmark.circle")
                    }
                    .tag(1)
                    
                    // Timeline Tab
                    NavigationView {
                        TimelineView()
                    }
                    .tabItem {
                        Label("Timeline", systemImage: "calendar")
                    }
                    .tag(2)
                    
                    // Profile Tab
                    NavigationView {
                        ProfileView(viewModel: authViewModel, onLogout: {
                            authViewModel.logout()
                        })
                    }
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
                    .tag(3)
                }
                .accentColor(AppColors.primary)
            } else {
                // Landing Page
                LandingPageView()
                    .environmentObject(authViewModel)
            }
        }
    }
}

// MARK: - Profile View
struct ProfileView: View {
    @ObservedObject var viewModel: AuthViewModel
    let onLogout: () -> Void
    @State private var showSubscriptionPaywall = false
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    // Profile Header
                    VStack(spacing: AppSpacing.md) {
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
                            
                            Text(viewModel.displayName.prefix(1).uppercased())
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: AppSpacing.sm) {
                            Text(viewModel.displayName)
                                .font(AppTypography.headline)
                                .fontWeight(.semibold)
                            
                            Text(viewModel.email)
                                .font(AppTypography.caption)
                                .foregroundColor(AppColors.textSecondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .applyCardStyle()
                    .padding(AppSpacing.lg)
                    
                    // Subscription Info
                    VStack(spacing: AppSpacing.md) {
                        HStack {
                            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                                Text("Subscription")
                                    .font(AppTypography.caption)
                                    .foregroundColor(AppColors.textSecondary)
                                
                                Text("Free Plan")
                                    .font(AppTypography.headline)
                                    .fontWeight(.semibold)
                            }
                            
                            Spacer()
                            
                            Button(action: { showSubscriptionPaywall = true }) {
                                Text("Upgrade")
                                    .font(AppTypography.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, AppSpacing.md)
                                    .padding(.vertical, AppSpacing.sm)
                                    .background(AppColors.primary)
                                    .cornerRadius(AppRadius.lg)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .applyCardStyle()
                    }
                    .padding(AppSpacing.lg)
                    
                    // Menu Items
                    VStack(spacing: AppSpacing.sm) {
                        MenuItemRow(icon: "gear", title: "Settings", subtitle: "Manage preferences")
                        MenuItemRow(icon: "bell", title: "Notifications", subtitle: "Update alerts")
                        MenuItemRow(icon: "questionmark.circle", title: "Help & Support", subtitle: "Get assistance")
                        MenuItemRow(icon: "doc.text", title: "Terms & Privacy", subtitle: "Legal info")
                    }
                    .padding(AppSpacing.lg)
                    
                    Spacer()
                    
                    // Logout Button
                    Button(action: onLogout) {
                        Text("Sign Out")
                            .applySecondaryButtonStyle()
                    }
                    .padding(AppSpacing.lg)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showSubscriptionPaywall) {
                SubscriptionPaywallView()
            }
        }
    }
}

// MARK: - Menu Item Row
struct MenuItemRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(AppColors.primary)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(title)
                    .font(AppTypography.body)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.text)
                
                Text(subtitle)
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(AppSpacing.md)
        .background(AppColors.surface)
        .cornerRadius(AppRadius.lg)
    }
}

// MARK: - Timeline View (Placeholder)
struct TimelineView: View {
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            VStack(spacing: AppSpacing.lg) {
                Text("Timeline")
                    .font(AppTypography.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(AppSpacing.lg)
                
                VStack(spacing: AppSpacing.md) {
                    ForEach(0..<3, id: \.self) { index in
                        TimelineItem(
                            date: "Day \(index + 1)",
                            title: "Milestone \(index + 1)",
                            description: "Complete this step",
                            isCompleted: index == 0
                        )
                    }
                }
                .padding(AppSpacing.lg)
                
                Spacer()
            }
            .navigationTitle("Timeline")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Timeline Item
struct TimelineItem: View {
    let date: String
    let title: String
    let description: String
    let isCompleted: Bool
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(isCompleted ? AppColors.success : AppColors.primary)
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: isCompleted ? "checkmark" : "circle.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
                
                if true {
                    Divider()
                        .frame(height: 24)
                        .padding(.vertical, AppSpacing.sm)
                }
            }
            
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text(date)
                    .font(AppTypography.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.primary)
                
                Text(title)
                    .font(AppTypography.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.text)
                
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

// MARK: - Auth View Model
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var displayName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    func signUp() async {
        isLoading = true
        errorMessage = nil
        
        // Simulate authentication
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        isAuthenticated = true
        isLoading = false
    }
    
    func signIn() async {
        isLoading = true
        errorMessage = nil
        
        // Simulate authentication
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        if !email.isEmpty && !password.isEmpty {
            isAuthenticated = true
        } else {
            errorMessage = "Invalid email or password"
        }
        isLoading = false
    }
    
    func logout() {
        isAuthenticated = false
        displayName = ""
        email = ""
        password = ""
    }
}

#Preview {
    ContentView()
}
