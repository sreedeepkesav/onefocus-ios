#!/bin/bash

# Phase 3 Verification Script
# Checks that all Phase 3 files have been created

echo "=========================================="
echo "OneFocus Phase 3 - File Verification"
echo "=========================================="
echo ""

PROJECT_ROOT="/Users/sreedeepkesavms/conductor/workspaces/1habit/kolkata/OneFocus"
MISSING=0
FOUND=0

check_file() {
    if [ -f "$PROJECT_ROOT/$1" ]; then
        echo "✅ $1"
        ((FOUND++))
    else
        echo "❌ MISSING: $1"
        ((MISSING++))
    fi
}

echo "Checking Settings Feature..."
check_file "OneFocus/Features/Settings/ViewModels/SettingsViewModel.swift"
check_file "OneFocus/Features/Settings/Views/SettingsView.swift"
check_file "OneFocus/Features/Settings/Components/SettingRow.swift"
echo ""

echo "Checking Insights Feature..."
check_file "OneFocus/Features/Insights/ViewModels/InsightsViewModel.swift"
check_file "OneFocus/Features/Insights/Views/InsightsView.swift"
check_file "OneFocus/Features/Insights/Components/CalendarHeatmap.swift"
check_file "OneFocus/Features/Insights/Components/InsightStatCard.swift"
echo ""

echo "Checking Services..."
check_file "OneFocus/Services/NotificationService.swift"
echo ""

echo "Checking Core..."
check_file "OneFocus/Core/DeepLinkHandler.swift"
echo ""

echo "Checking Second Habit Flow..."
check_file "OneFocus/Features/SecondHabit/Views/SecondHabitOnboardingFlow.swift"
echo ""

echo "Checking Widget Files..."
check_file "OneFocusWidget/OneFocusWidget.swift"
check_file "OneFocusWidget/OneFocusWidgetBundle.swift"
check_file "OneFocusWidget/Info.plist"
echo ""

echo "Checking Updated Files..."
check_file "OneFocus/OneFocusApp.swift"
check_file "OneFocus/Features/Home/Views/HomeView.swift"
check_file "OneFocus/Features/Home/ViewModels/HomeViewModel.swift"
check_file "OneFocus/Features/Onboarding/OnboardingViewModel.swift"
check_file "OneFocus/Features/Onboarding/OnboardingContainerView.swift"
check_file "OneFocus/Services/DataService.swift"
check_file "OneFocus/Info.plist"
echo ""

echo "Checking Documentation..."
check_file "SETUP_PHASE3.md"
check_file "PHASE3_SUMMARY.md"
check_file "PHASE3_FILES.md"
check_file "NEXT_STEPS.md"
echo ""

echo "=========================================="
echo "Verification Results:"
echo "  Found: $FOUND files"
echo "  Missing: $MISSING files"
echo "=========================================="
echo ""

if [ $MISSING -eq 0 ]; then
    echo "✅ All Phase 3 files are present!"
    echo ""
    echo "Next steps:"
    echo "  1. Run: ./add_files_to_xcode.sh"
    echo "  2. Follow instructions in SETUP_PHASE3.md"
    echo "  3. Build and test the app"
    echo ""
else
    echo "❌ Some files are missing. Please check the output above."
    exit 1
fi
