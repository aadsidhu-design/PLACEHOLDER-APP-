
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            BusinessIdeasView()
                .tabItem {
                    Label("Ideas", systemImage: "lightbulb")
                }
            DailyGoalsView()
                .tabItem {
                    Label("Goals", systemImage: "list.bullet.clipboard")
                }
            MilestonesView()
                .tabItem {
                    Label("Milestones", systemImage: "flag")
                }
            TimelineView()
                .tabItem {
                    Label("Timeline", systemImage: "calendar")
                }
            AIAssistantView()
                .tabItem {
                    Label("Assistant", systemImage: "message")
                }
        }
    }
}
