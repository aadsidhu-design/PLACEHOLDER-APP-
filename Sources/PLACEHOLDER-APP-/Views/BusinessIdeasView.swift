
import SwiftUI

struct BusinessIdeasView: View {
    var body: some View {
        VStack {
            Text("Business Ideas")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    BusinessIdeaCard(idea: "Personalized Meal Kit Delivery", description: "A subscription service that delivers pre-portioned ingredients and recipes for healthy meals tailored to individual dietary needs and preferences.")
                    BusinessIdeaCard(idea: "AI-Powered Fitness Coach", description: "A mobile app that uses AI to create personalized workout plans, track progress, and provide real-time feedback.")
                    BusinessIdeaCard(idea: "Sustainable Fashion Marketplace", description: "An online marketplace for buying and selling second-hand and sustainable clothing.")
                }
                .padding()
            }
        }
        .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
    }
}

struct BusinessIdeaCard: View {
    let idea: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(idea)
                .font(.headline)
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
