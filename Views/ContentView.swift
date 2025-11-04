import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var ideaViewModel: IdeaViewModel
    @State private var selectedTab: Tab = .home
    
    enum Tab {
        case home
        case ideas
        case goals
        case profile
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            NavigationView {
                VStack(spacing: 20) {
                    Text("Welcome back!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            if ideaViewModel.businessIdeas.isEmpty {
                                Text("No ideas yet. Start the quiz!")
                                    .foregroundColor(.gray)
                            } else {
                                ForEach(ideaViewModel.businessIdeas.prefix(3)) { idea in
                                    IdeaCardView(idea: idea)
                                }
                            }
                        }
                        .padding()
                    }
                }
                .navigationTitle("Dashboard")
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(Tab.home)
            
            // Ideas Tab
            NavigationView {
                VStack {
                    if ideaViewModel.isLoading {
                        ProgressView()
                    } else if ideaViewModel.businessIdeas.isEmpty {
                        VStack(spacing: 20) {
                            Text("No business ideas yet")
                                .font(.headline)
                            Text("Complete the quiz to get personalized ideas")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding()
                    } else {
                        List(ideaViewModel.businessIdeas) { idea in
                            NavigationLink(destination: IdeaDetailView(idea: idea)) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(idea.title)
                                        .font(.headline)
                                    Text(idea.summary)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .lineLimit(2)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Business Ideas")
            }
            .tabItem {
                Label("Ideas", systemImage: "lightbulb.fill")
            }
            .tag(Tab.ideas)
            
            // Goals Tab
            NavigationView {
                GoalListView()
            }
            .tabItem {
                Label("Goals", systemImage: "checkmark.circle.fill")
            }
            .tag(Tab.goals)
            
            // Profile Tab
            VStack(spacing: 20) {
                Text("Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Account Settings")
                        .font(.headline)
                    
                    Button(action: authViewModel.signOut) {
                        Text("Sign Out")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
                
                Spacer()
            }
            .tabItem {
                Label("Profile", systemImage: "person.circle.fill")
            }
            .tag(Tab.profile)
        }
    }
}

struct IdeaCardView: View {
    let idea: BusinessIdea
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(idea.title)
                        .font(.headline)
                    Text(idea.summary)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }
                Spacer()
                Image(systemName: idea.isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(idea.isFavorite ? .red : .gray)
            }
            
            HStack(spacing: 8) {
                Label("\(idea.roughTimelineWeeks)w", systemImage: "calendar")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Label(idea.estimatedStartupCostRange, systemImage: "dollarsign.circle")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
        .environmentObject(IdeaViewModel())
        .environmentObject(QuizViewModel())
        .environmentObject(GoalViewModel())
}
