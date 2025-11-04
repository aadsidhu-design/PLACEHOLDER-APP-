# BusinessIdeaApp - Architecture Overview

## Project Structure

```
BusinessIdeaApp/
├── App/
│   └── BusinessIdeaApp.swift              # @main entry point
├── Config/
│   ├── DesignTokens.swift                 # Design system
│   ├── SecureConfig.swift                 # Secure API config
│   └── Config.swift
├── Models/
│   ├── Goal.swift
│   ├── Milestone.swift
│   ├── BusinessIdea.swift
│   ├── QuizResponse.swift
│   └── User.swift
├── Services/
│   ├── GoogleAIService.swift
│   ├── FirebaseService.swift
│   └── QuizEngine.swift
├── ViewModels/
│   ├── AuthViewModel.swift
│   ├── GoalViewModel.swift
│   ├── IdeaViewModel.swift
│   └── QuizViewModel.swift
├── Views/
│   ├── LandingPageView.swift
│   ├── QuizView.swift
│   ├── BusinessIdeasView.swift
│   ├── IdeaDetailView.swift
│   ├── GoalListView.swift
│   ├── SubscriptionPaywallView.swift
│   ├── ContentView.swift
│   └── ChartsAndGraphsView.swift
├── Resources/
│   └── Info.plist
├── Package.swift
└── Docs/
    └── (11 documentation files)
```

## Architecture Pattern

### MVVM (Model-View-ViewModel)

```
Model Layer
├── Goal, Milestone, BusinessIdea, User, QuizResponse

ViewModel Layer  
├── AuthViewModel
├── GoalViewModel
├── IdeaViewModel
└── QuizViewModel

View Layer
├── LandingPageView
├── QuizView
├── BusinessIdeasView
├── IdeaDetailView
├── GoalListView
├── SubscriptionPaywallView
├── ContentView
└── ChartsAndGraphsView
```

## Design System

### AppColors
- `primary` - iOS Blue (0, 0.48, 1.0)
- `accent` - Cyan (0, 0.95, 1.0)
- `success` - Green
- `warning` - Orange
- `danger` - Red

### AppTypography
- largeTitle, title1, title2, title3
- headline, body, caption, caption2

### AppSpacing
- xs (4), sm (8), md (12), lg (16), xl (24), xxl (32)

### Modifiers
- `applyCardStyle()`
- `applyButtonStyle()`
- `applySecondaryButtonStyle()`

## Data Flow

1. **User opens app** → LandingPageView
2. **Sign up/in** → AuthViewModel
3. **Complete quiz** → QuizViewModel → QuizResultsView
4. **Generate ideas** → IdeaViewModel → BusinessIdeasView
5. **Create goals** → GoalViewModel → GoalListView with Charts
6. **View subscription** → SubscriptionPaywallView
7. **Main navigation** → ContentView (tabs)

## Security

- API keys in Info.plist (build-time substitution)
- SecureConfig runtime loader
- Environment variable fallback
- Startup validation

## Services

### GoogleAIService
- Ready to integrate with Google AI Studio
- Secure key loading via SecureConfig
- Error handling with 5 error types

### FirebaseService
- Ready to integrate with Firebase
- Authentication ready
- Database schema ready

### QuizEngine
- Quiz logic and scoring
- Question bank management
- Response validation

## State Management

- `@StateObject` for persistent ViewModels
- `@EnvironmentObject` for shared state
- `@State` for local view state
- `@Binding` for two-way data flow

## Charts & Analytics

- ProgressChartView (circular progress)
- PriorityDistributionChart (bar chart)
- StatusOverviewView (stat cards)
- Real-time data binding
- Smooth animations

---

For implementation details, see API_REFERENCE.md
