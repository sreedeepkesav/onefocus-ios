# Phase 3 Setup Instructions

## Manual Steps Required

Since we've created new Swift files and a widget extension outside of Xcode, you'll need to manually add them to the Xcode project. Follow these steps:

### Step 1: Open the Xcode Project
```bash
open /Users/sreedeepkesavms/conductor/workspaces/1habit/kolkata/OneFocus/OneFocus.xcodeproj
```

### Step 2: Add New Swift Files to Main App Target

Right-click on the appropriate folders in Xcode and add the following files:

#### Settings Feature
- Right-click `Features` → Add Files → Select:
  - `Features/Settings/` folder (with all contents)

#### Insights Feature  
- Right-click `Features` → Add Files → Select:
  - `Features/Insights/` folder (with all contents)

#### Services
- Right-click `Services` → Add Files → Select:
  - `Services/NotificationService.swift`

#### Core
- Right-click `Core` → Add Files → Select:
  - `Core/DeepLinkHandler.swift`

#### Second Habit Flow
- Right-click `Features/SecondHabit/Views` → Add Files → Select:
  - `Features/SecondHabit/Views/SecondHabitOnboardingFlow.swift`

**Important:** When adding files, make sure to:
- ✅ Check "Copy items if needed" (should be unchecked since files are already in place)
- ✅ Select target: OneFocus
- ✅ Create groups (not folder references)

### Step 3: Create Widget Extension Target

1. In Xcode: File → New → Target
2. Select "Widget Extension"
3. Product Name: `OneFocusWidget`
4. Include Configuration Intent: ❌ (Uncheck)
5. Click Finish
6. When prompted to activate scheme, click "Activate"

### Step 4: Configure Widget Target

1. Delete the auto-generated widget files (OneFocusWidget.swift, etc.) that Xcode created
2. Add the custom widget files we created:
   - Right-click `OneFocusWidget` group → Add Files
   - Select `OneFocusWidget/OneFocusWidget.swift`
   - Select `OneFocusWidget/OneFocusWidgetBundle.swift`
   - **Important:** Check target membership for `OneFocusWidget` only

3. Configure Widget Target Settings:
   - Select OneFocusWidget target
   - General tab:
     - Bundle Identifier: `com.onefocus.OneFocusWidget`
     - Deployment Target: iOS 17.0
   - Signing & Capabilities:
     - Add App Groups capability
     - Check: `group.com.onefocus.shared`

### Step 5: Share Code with Widget

The widget needs access to some main app files. Add these files to the widget target:

1. Select each file below and in File Inspector (right panel), check the box for `OneFocusWidget` target:
   - `Models/Habit.swift`
   - `Models/Journey.swift`
   - `Models/MoodEntry.swift`
   - `Models/RepeatingLog.swift`
   - `Models/Enums/HabitType.swift`
   - `Models/Enums/TriggerType.swift`
   - `Services/DataService.swift`
   - `Core/Design/Colors.swift`
   - `Core/Design/Typography.swift`

### Step 6: Configure App Groups

1. Select the main app target (OneFocus)
2. Go to Signing & Capabilities tab
3. If not already added, click "+ Capability" → App Groups
4. Check `group.com.onefocus.shared`

### Step 7: Verify Info.plist Updates

The Info.plist files should already be updated, but verify:

**Main App Info.plist:**
- Contains CFBundleURLTypes with scheme "onefocus"

**Widget Info.plist:**
- Contains NSExtension configuration

### Step 8: Build the Project

1. Select the OneFocus scheme (not OneFocusWidget)
2. Choose a simulator or device
3. Press Cmd+B to build
4. Fix any compilation errors that arise

### Step 9: Test Widget

1. Run the app on simulator/device
2. Long-press home screen → Add Widget
3. Find "OneFocus" in widget gallery
4. Add both Small and Medium widgets
5. Verify they display correctly

### Step 10: Test Deep Linking

Test widget deep links work:
```bash
xcrun simctl openurl booted "onefocus://home"
xcrun simctl openurl booted "onefocus://focus"
```

## Common Issues and Solutions

### Issue: Files appear red in Xcode
**Solution:** The files weren't added properly. Delete references and re-add using "Add Files to OneFocus"

### Issue: Widget doesn't compile
**Solution:** Make sure all shared model files have OneFocusWidget target checked in File Inspector

### Issue: "No such module 'WidgetKit'"
**Solution:** Make sure deployment target is iOS 14.0+ and WidgetKit framework is linked

### Issue: Widget shows placeholder
**Solution:** Make sure app and widget share the same App Group and data is being saved

### Issue: Deep links don't work
**Solution:** Verify Info.plist has CFBundleURLTypes configured correctly

## Verification Checklist

Before committing, verify:
- [ ] App builds successfully (Cmd+B)
- [ ] Widget target builds successfully
- [ ] Settings screen opens and displays correctly
- [ ] Insights screen shows calendar heatmap
- [ ] Notifications can be enabled/disabled
- [ ] Small widget displays on home screen
- [ ] Medium widget displays on home screen
- [ ] Widget updates when habit is completed
- [ ] Deep links work from widgets
- [ ] Second habit flow can be triggered at day 21
- [ ] All new screens follow dark mode design
- [ ] VoiceOver labels are present

## Build Command

After adding files to Xcode project, build with:
```bash
cd /Users/sreedeepkesavms/conductor/workspaces/1habit/kolkata/OneFocus
xcodebuild -scheme OneFocus -configuration Debug -sdk iphonesimulator -arch x86_64 clean build
```

## Next Steps After Successful Build

1. Test all new features thoroughly
2. Commit changes:
```bash
git add .
git commit -m "feat(ios): Phase 3 - Analytics, Widgets, Notifications, and Settings

- Implemented Settings screen with notification preferences
- Added NotificationService with daily reminders and milestones
- Created Insights/Analytics screen with calendar heatmap
- Built WidgetKit extension with Small and Medium widgets
- Integrated second habit flow with onboarding
- Added deep linking support (onefocus://)
- Extended DataService with analytics methods
- Updated HomeView with all Phase 3 features

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"

git push origin main
```
