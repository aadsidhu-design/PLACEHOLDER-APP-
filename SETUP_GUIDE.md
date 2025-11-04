# Setup Guide

## Prerequisites
- Xcode 15.0 or later
- iOS 14.0 or later
- CocoaPods

## Installation Steps

### 1. Clone the Repository
```bash
git clone https://github.com/aadsidhu-design/PLACEHOLDER-APP-.git
cd PLACEHOLDER-APP-
```

### 2. Install CocoaPods Dependencies
```bash
sudo gem install cocoapods
pod install
```

### 3. Open Xcode Workspace
```bash
open BusinessIdea.xcworkspace
```

### 4. Configure Firebase

1. Download `GoogleService-Info.plist` from [Firebase Console](https://console.firebase.google.com/project/studio-5837146656-10acf):
   - Go to Project Settings
   - Download the iOS config file

2. Add to Xcode:
   - Drag `GoogleService-Info.plist` into Xcode
   - Check "Copy items if needed"
   - Select the `BusinessIdea` target

3. Verify in Build Phases:
   - Select target → Build Phases → Copy Bundle Resources
   - Ensure `GoogleService-Info.plist` is listed

### 5. Configure API Keys

Create environment variables for API keys:

**For Google AI Studio:**
1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Copy your API key
3. In Xcode Scheme:
   - Edit Scheme → Run → Pre-actions
   - Add environment variable: `GOOGLE_AI_API_KEY=YOUR_KEY`

Alternatively, add to `.env` file (see `.gitignore`):
```
GOOGLE_AI_API_KEY=YOUR_KEY_HERE
```

### 6. Build and Run

```bash
# Build
xcodebuild -workspace BusinessIdea.xcworkspace -scheme BusinessIdea -configuration Debug

# Or run in simulator
xcodebuild -workspace BusinessIdea.xcworkspace -scheme BusinessIdea -configuration Debug -simulator
```

Or simply press `Cmd + R` in Xcode.

## Project Structure

```
BusinessIdea/
├── App/                           # Entry point
│   ├── BusinessIdeaApp.swift      # @main app
│   └── AppDelegate.swift          # Firebase setup
├── Models/                        # Data structures
│   ├── User.swift
│   ├── QuizResponse.swift
│   ├── BusinessIdea.swift
│   ├── Goal.swift
│   └── Milestone.swift
├── Services/                      # Business logic
│   ├── FirebaseService.swift      # Auth, Firestore CRUD
│   ├── GoogleAIService.swift      # AI idea generation
│   ├── QuizEngine.swift           # Quiz logic
│   └── SubscriptionService.swift  # In-app purchases
├── ViewModels/                    # State management
│   ├── AuthViewModel.swift
│   ├── QuizViewModel.swift
│   ├── IdeaViewModel.swift
│   └── GoalViewModel.swift
├── Views/                         # SwiftUI screens
│   ├── ContentView.swift          # Main tab view
│   ├── LandingPageView.swift      # Onboarding
│   ├── QuizView.swift             # Quiz flow
│   ├── IdeaDetailView.swift       # Idea details
│   ├── GoalListView.swift         # Goals & timeline
│   └── SubscriptionView.swift     # Paywall
├── Config/                        # Configuration
│   └── Config.swift               # API keys, constants
├── Resources/
│   └── GoogleService-Info.plist   # Firebase config (ignored)
├── Podfile                        # CocoaPods dependencies
└── README.md                      # Documentation
```

## Firebase Configuration

### Firestore Collections

**users**
```json
{
  "id": "uid",
  "email": "user@example.com",
  "displayName": "John Doe",
  "skillsets": ["iOS Development"],
  "interests": ["SaaS"],
  "personalityTraits": ["Analytical"],
  "riskTolerance": "medium",
  "availableHoursPerWeek": 20,
  "budgetRange": "$2000-5000",
  "createdAt": "timestamp"
}
```

**quizResponses**
```json
{
  "userId": "uid",
  "answers": { ... },
  "profileVector": {
    "skillScore": 0.8,
    "interestScore": 0.7,
    "personalityScore": 0.6,
    "riskScore": 0.5,
    "resourceScore": 0.9
  },
  "createdAt": "timestamp"
}
```

**businessIdeas**
```json
{
  "userId": "uid",
  "title": "SaaS Platform",
  "summary": "...",
  "detailedDescription": "...",
  "requiredSkills": ["Swift", "Backend"],
  "roughTimelineWeeks": 12,
  "first30DayPlan": ["task1", "task2"],
  "revenueModelHint": "...",
  "estimatedStartupCostRange": "$2000-5000",
  "tags": ["SaaS"],
  "createdAt": "timestamp"
}
```

**goals**
```json
{
  "ideaId": "ideaId",
  "userId": "uid",
  "title": "Validate idea",
  "description": "...",
  "dueDate": "timestamp",
  "status": "pending",
  "priority": "high",
  "createdAt": "timestamp"
}
```

**milestones**
```json
{
  "ideaId": "ideaId",
  "userId": "uid",
  "title": "MVP Launch",
  "startDate": "timestamp",
  "endDate": "timestamp",
  "progress": 0.5,
  "goals": ["goalId1", "goalId2"],
  "createdAt": "timestamp"
}
```

## Troubleshooting

### Pod Install Issues
```bash
rm -rf Pods Podfile.lock
pod install --repo-update
```

### Firebase Not Initializing
- Verify `GoogleService-Info.plist` is in the project and added to target.
- Check Xcode Console for Firebase initialization errors.

### Google AI API Errors
- Ensure `GOOGLE_AI_API_KEY` environment variable is set.
- Check API quota in [Google Cloud Console](https://console.cloud.google.com).
- Verify API is enabled for `generativelanguage.googleapis.com`.

### Compilation Errors
- Clean build folder: `Cmd + Shift + K`
- Delete DerivedData: `rm -rf ~/Library/Developer/Xcode/DerivedData/*`
- Reinstall pods: `pod install --repo-update`

## Development Workflow

1. Create a branch: `git checkout -b feature/your-feature`
2. Make changes and test on simulator
3. Commit: `git commit -am 'Add feature'`
4. Push: `git push origin feature/your-feature`
5. Open a PR on GitHub

## Next Steps

- [ ] Add subscription/paywall logic
- [ ] Implement in-app purchases (StoreKit2)
- [ ] Add analytics and crash reporting
- [ ] Optimize AI prompt templates
- [ ] Create unit tests
- [ ] Prepare for App Store submission

## Support
For issues or questions, open a GitHub Issue.
