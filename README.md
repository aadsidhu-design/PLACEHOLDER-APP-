# BusinessIdea iOS App

An iOS app that generates personalized business ideas based on user skillsets, personality, and interests.

## Features
- **Smart Quiz**: Onboarding quiz to capture user profile (skills, interests, personality, resources).
- **AI-Powered Ideas**: Generate 3–7 personalized business ideas using Google AI Studio.
- **Goal Tracking**: Create daily goals and milestones for each business idea.
- **Timeline View**: Visualize 30-day plan and long-term milestones.
- **Subscription**: Premium features via Apple App Store in-app purchases.

## Tech Stack
- **Language**: Swift
- **UI Framework**: SwiftUI
- **Backend**: Firebase (Authentication, Firestore Database, Analytics)
- **AI**: Google AI Studio (Gemini API)
- **Payments**: Apple App Store in-app purchases

## Project Structure
```
BusinessIdea/
├── App/
│   ├── BusinessIdeaApp.swift          # Entry point
│   └── AppDelegate.swift              # Firebase config
├── Models/
│   ├── User.swift
│   ├── QuizResponse.swift
│   ├── BusinessIdea.swift
│   ├── Goal.swift
│   └── Milestone.swift
├── Services/
│   ├── FirebaseService.swift          # Auth, Firestore CRUD
│   ├── GoogleAIService.swift          # AI idea generation
│   └── SubscriptionService.swift      # In-app purchases
├── ViewModels/
│   ├── AuthViewModel.swift
│   ├── QuizViewModel.swift
│   ├── IdeaViewModel.swift
│   └── GoalViewModel.swift
├── Views/
│   ├── ContentView.swift
│   ├── LandingPageView.swift
│   ├── QuizView.swift
│   ├── QuizResultsView.swift
│   ├── IdeaDetailView.swift
│   ├── GoalListView.swift
│   ├── TimelineView.swift
│   └── SubscriptionView.swift
└── Resources/
    └── GoogleService-Info.plist       # Firebase config (git-ignored)
```

## Setup

### Prerequisites
- Xcode 15.0+
- iOS 14.0+
- CocoaPods

### Installation
1. Clone the repo:
   ```bash
   git clone https://github.com/aadsidhu-design/PLACEHOLDER-APP-.git
   cd PLACEHOLDER-APP-
   ```

2. Install dependencies via CocoaPods:
   ```bash
   pod install
   ```

3. Open the workspace:
   ```bash
   open BusinessIdea.xcworkspace
   ```

4. Add Firebase config:
   - Download `GoogleService-Info.plist` from Firebase Console.
   - Drag into Xcode and select "Copy items if needed".

5. Build and run on simulator or device.

## Configuration

### Environment Variables
Create a `Config.swift` file (not in repo):
```swift
struct Config {
    static let googleAIKey = "YOUR_GOOGLE_AI_API_KEY"
    static let firebaseProjectID = "studio-5837146656-10acf"
}
```

### API Keys
- **Firebase Project ID**: `studio-5837146656-10acf`
- **Google AI API**: Provided via Config (keep private).

## Development Roadmap
- [x] Project setup & Firebase integration
- [ ] Quiz question bank & scoring logic
- [ ] AI idea generation (Google AI Studio)
- [ ] SwiftUI landing, quiz, results pages
- [ ] Goal/milestone CRUD & timeline UI
- [ ] In-app subscriptions (RevenueCat or StoreKit2)
- [ ] Testing & optimization
- [ ] App Store submission

## Contributing
1. Create a feature branch: `git checkout -b feature/your-feature`
2. Commit changes: `git commit -am 'Add feature'`
3. Push to branch: `git push origin feature/your-feature`
4. Open a pull request.

## License
MIT License. See LICENSE file for details.

## Contact
Aadjot Sidhu — [@aadsidhu-design](https://github.com/aadsidhu-design)
