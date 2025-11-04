# Build Guide - BusinessIdeaApp

## Prerequisites

- Xcode 15+
- Swift 5.9+
- iOS 14+ (target)
- macOS 12+ (build machine)

## Building from Source

### 1. Clone Repository

```bash
git clone https://github.com/aadsidhu-design/PLACEHOLDER-APP-
cd PLACEHOLDER-APP-
```

### 2. Open in Xcode

```bash
open Package.swift
```

Xcode will automatically recognize this as a Swift package.

### 3. Configure Build Settings

**For API Key Support:**

1. Target → Build Settings
2. Search "GOOGLE_AI_API_KEY"
3. Add to Debug configuration: `(Leave empty for now, add later)`
4. Add to Release configuration: `(Leave empty for now, add later)`

### 4. Build

**Via Xcode:**
```
Cmd + B
```

**Via Command Line:**
```bash
swift build
```

### 5. Run in Simulator

**Via Xcode:**
```
Cmd + R
```

**Via Command Line:**
```bash
swift run
```

### 6. Test on Device (When Ready)

1. Connect physical iPhone
2. Select device in Xcode
3. Cmd + R to build and run

## Troubleshooting Builds

### Issue: Cannot find module 'SwiftUI'
**Solution:** Ensure iOS 14+ is selected as target

### Issue: Missing 'AppColors'
**Solution:** Ensure Config/DesignTokens.swift is included in target

### Issue: Build fails with dependency error
**Solution:** 
```bash
rm -rf .build
swift clean
swift build
```

### Issue: Simulator won't launch app
**Solution:**
```bash
xcrun simctl erase all
# Then try again
```

## Build Configurations

### Debug
- Optimization: None
- Symbols: Included
- Good for: Development and testing

### Release
- Optimization: Full
- Symbols: Stripped
- Good for: App Store distribution

## Testing Build

### Manual Testing Checklist

- [ ] App launches without crashes
- [ ] Landing page displays
- [ ] Quiz loads all 5 questions
- [ ] Results calculate correctly
- [ ] Ideas display in cards
- [ ] Goal list with charts works
- [ ] Tab navigation functions
- [ ] Profile page accessible
- [ ] Animations are smooth
- [ ] All colors consistent

### Automated Testing (Future)

When ready:
```bash
swift test
```

## Performance Optimization

### Current Optimizations
- ✅ Async/await for non-blocking operations
- ✅ Lazy loading in lists
- ✅ View caching

### Future Optimizations
- [ ] Add Core Data for offline storage
- [ ] Implement image caching
- [ ] Add performance monitoring
- [ ] Optimize list rendering

## Code Signing (For Device Testing)

1. Xcode → Preferences → Accounts
2. Add Apple ID
3. Select team in Build Settings
4. Allow automatic code signing

## App Distribution

### For TestFlight

1. Create App in App Store Connect
2. Archive build: Product → Archive
3. Distribute via TestFlight
4. Invite testers

### For App Store

1. Ensure release build passes all checks
2. Archive: Product → Archive
3. Export for App Store
4. Submit via App Store Connect

See DELIVERY.md for detailed submission process.

## CI/CD Setup (Future)

When ready, integrate with:
- GitHub Actions
- fastlane
- Firebase Test Lab

---

**Current Status**: ✅ Builds and runs successfully
