
import SwiftUI

struct SubscriptionPaywallView: View {
    var body: some View {
        VStack {
            Text("Subscribe for Premium Features")
                .font(.largeTitle)
                .padding()
            Text("Unlock daily goals, milestones, timeline, and AI assistant.")
                .padding()
            NavigationLink(destination: MainTabView()) {
                Text("Subscribe Now")
                    .font(.title)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}
