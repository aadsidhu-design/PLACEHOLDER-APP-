# Quick Start

## TL;DR

```bash
# Clone
git clone https://github.com/aadsidhu-design/PLACEHOLDER-APP-.git && cd PLACEHOLDER-APP-

# Install pods
pod install

# Open workspace
open BusinessIdea.xcworkspace

# In Xcode:
# 1. Add GoogleService-Info.plist from Firebase Console
# 2. Set GOOGLE_AI_API_KEY in Scheme Environment Variables
# 3. Press Cmd+R to run
```

## What's Included

✅ **Complete iOS Swift scaffold** with SwiftUI  
✅ **Firebase integration** (Auth, Firestore, Analytics)  
✅ **Google AI Studio** integration for idea generation  
✅ **Quiz engine** with 10 adaptive questions  
✅ **Landing page, Quiz, Results, Idea detail, Goals/Timeline views**  
✅ **Data models** for User, Quiz, Idea, Goal, Milestone  
✅ **ViewModels** for state management  
✅ **Services** for Firebase CRUD and AI API calls  

## Next Immediate Tasks

1. **In-App Purchases** (StoreKit2)
   - Create `SubscriptionService.swift`
   - Add subscription view and paywall
   - Integrate with Apple App Store

2. **Testing**
   - Unit tests for `QuizEngine.calculateProfileVector()`
   - Integration tests for Firebase CRUD
   - Mock Google AI responses

3. **Polish**
   - Refine colors, fonts, spacing (use Figma or design tokens)
   - Add animations and loading states
   - Test accessibility (VoiceOver, Dynamic Type)

4. **Analytics**
   - Log events for quiz completion, idea generation, subscription signup
   - Set up Firebase Analytics dashboard

## Repository Status

**Branch:** `main`  
**Latest Commit:** Scaffold complete with all core views, models, services, and Firebase setup  
**Ready for:** Local development, testing, and iOS App Store submission prep

## Key Files

| File | Purpose |
|------|----------|
| `App/BusinessIdeaApp.swift` | App entry point, environment setup |
| `Models/*.swift` | Data structures (Codable, Firestore-compatible) |
| `Services/FirebaseService.swift` | Auth, Firestore CRUD, Analytics logging |
| `Services/GoogleAIService.swift` | Idea generation via Gemini API |
| `Services/QuizEngine.swift` | 10-question quiz with scoring |
| `ViewModels/*.swift` | MVVM state containers |
| `Views/*.swift` | SwiftUI screens (landing, quiz, ideas, goals) |
| `Config/Config.swift` | App configuration and constants |
| `Podfile` | CocoaPods dependencies (Firebase, etc.) |
| `SETUP_GUIDE.md` | Detailed setup with Firebase schema |

## Environment Setup

### Xcode Scheme Configuration

1. In Xcode: `Product` → `Scheme` → `Edit Scheme`
2. Go to `Run` → `Pre-actions`
3. Add environment variable:
   ```
   GOOGLE_AI_API_KEY=YOUR_KEY_FROM_GOOGLE_AI_STUDIO
   ```

Alternatively, create a local `.env` file (ignored in `.gitignore`) and load in app startup.

## Firebase Setup

1. [Firebase Console](https://console.firebase.google.com/project/studio-5837146656-10acf)
2. Download iOS config: `GoogleService-Info.plist`
3. Drag into Xcode, select `BusinessIdea` target
4. Enable:
   - Authentication (Email/Password)
   - Firestore (with collection-level security rules)
   - Analytics

### Firestore Security Rules (example)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own documents
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    
    // Quiz responses, ideas, goals scoped to user
    match /quizResponses/{docId} {
      allow read, write: if request.auth.uid == resource.data.userId;
    }
    
    match /businessIdeas/{docId} {
      allow read, write: if request.auth.uid == resource.data.userId;
    }
    
    match /goals/{docId} {
      allow read, write: if request.auth.uid == resource.data.userId;
    }
    
    match /milestones/{docId} {
      allow read, write: if request.auth.uid == resource.data.userId;
    }
  }
}
```

## Testing Locally

### Simulator
```bash
xcodebuild -workspace BusinessIdea.xcworkspace -scheme BusinessIdea -configuration Debug -simulator
```

### Device
- Connect iPhone/iPad
- Select device in Xcode
- Press `Cmd + R`

### Firebase Emulator (optional, for offline dev)
```bash
firebase emulators:start --only firestore,auth
```

## Common Issues & Fixes

| Issue | Solution |
|-------|----------|
| Pod install fails | `pod repo update && pod install --repo-update` |
| Firebase not found | Ensure `GoogleService-Info.plist` added to target |
| Google AI timeout | Check API key in Xcode Scheme, verify quota |
| Firestore data empty | Check Firestore security rules, user UID |
| Compilation errors | Clean build: `Cmd + Shift + K`, delete DerivedData |

## Deployment Roadmap

### Phase 1: MVP (Current)
- [x] Basic quiz & idea generation
- [x] Goal/milestone tracking
- [x] Firebase auth & data persistence
- [ ] In-app purchases (next)

### Phase 2: Production
- [ ] Analytics dashboard
- [ ] Push notifications
- [ ] Offline support (Core Data sync)
- [ ] Premium AI features

### Phase 3: App Store
- [ ] Privacy policy & terms
- [ ] App Store assets (screenshots, icons)
- [ ] Beta testing (TestFlight)
- [ ] Submit for review

## Support

- **Documentation:** See `SETUP_GUIDE.md` for detailed setup
- **Issues:** Open GitHub Issue
- **PR:** Create feature branch, test locally, submit PR

## License

MIT License © Aadjot Sidhu
