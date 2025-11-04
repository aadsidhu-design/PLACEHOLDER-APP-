
import SwiftUI

struct SubscriptionPaywallView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Subscribe for Premium Features")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()
            
            Text("Unlock daily goals, milestones, timeline, and AI assistant.")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
            
            NavigationLink(destination: MainTabView().navigationBarBackButtonHidden(true)) {
                Text("Subscribe Now")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
    }
}
