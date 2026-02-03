#!/usr/bin/env python3
"""
Script to add Phase 2 and Phase 3 Swift files to OneFocus Xcode project.
This modifies project.pbxproj to register all new files.
"""

import re
import sys

# Files to add with their UUIDs (generated consistently)
FILES_TO_ADD = [
    # (filename, path, buildFileUUID, fileRefUUID)
    # Phase 2 files
    ("HomeViewModel.swift", "OneFocus/Features/Home/ViewModels/HomeViewModel.swift", "07D041883BE510BDDDF587E2", "BF7868A747472C4C725C0352"),
    ("JourneyCard.swift", "OneFocus/Features/Home/Components/JourneyCard.swift", "1F79C77297FFC1BA34EF21F3", "232370BD79FDD1881CDB8A3A"),
    ("HabitCard.swift", "OneFocus/Features/Home/Components/HabitCard.swift", "A4CF2B3268980E553331829D", "C939E6E211279993D0547AE0"),
    ("ProgressRing.swift", "OneFocus/Features/Home/Components/ProgressRing.swift", "E2E19CB7219914378E954A1F", "6776B6E5BD85521FA1C0A39B"),
    ("StatsRow.swift", "OneFocus/Features/Home/Components/StatsRow.swift", "0A59C034B7EF2BB43EBF5D81", "CF5F4056030B68B19711164F"),
    ("FocusView.swift", "OneFocus/Features/Focus/Views/FocusView.swift", "D03F0BF72A78700A89B56B7C", "02596216083641351BD7E3BF"),
    ("FocusViewModel.swift", "OneFocus/Features/Focus/ViewModels/FocusViewModel.swift", "7A6F3558E46E7A66FAD3809D", "E4F824AA1A396BFA022F0871"),
    ("BreathingCircle.swift", "OneFocus/Features/Focus/Components/BreathingCircle.swift", "C5ABA49C221BD35940DED526", "F82FA89A7CEEB3BCADF5A84B"),
    ("CelebrationView.swift", "OneFocus/Features/Focus/Views/CelebrationView.swift", "0DE1A8BAC87CA839BFB45129", "FDA6DB7F1A9C60D585932267"),
    ("MoodBeforeView.swift", "OneFocus/Features/Mood/Views/MoodBeforeView.swift", "3F189FE66A780AB7A8719BDA", "47C45707D682E6ABFACAC93F"),
    ("MoodAfterView.swift", "OneFocus/Features/Mood/Views/MoodAfterView.swift", "2D91BDBC79A859E7C877ABAA", "D6B12774533C6B10C1A1CC68"),
    ("MoodViewModel.swift", "OneFocus/Features/Mood/ViewModels/MoodViewModel.swift", "DFE56626592B18045D6217B4", "3F4E469070A7C05E947442E2"),
    ("AddSecondHabitView.swift", "OneFocus/Features/SecondHabit/Views/AddSecondHabitView.swift", "33B6FC6474424B644DDB2765", "101D18436981504F57F5DB2B"),
    # Phase 3 files
    ("NotificationService.swift", "OneFocus/Services/NotificationService.swift", "E508452BCFC9DBE7E8A9EA6A", "436DDE6854272E20CDC0EC5C"),
    ("DeepLinkHandler.swift", "OneFocus/Core/DeepLinkHandler.swift", "FCB550AA94F112B86746C4AD", "D7E6782BDD60849DB444B827"),
    ("InsightsViewModel.swift", "OneFocus/Features/Insights/ViewModels/InsightsViewModel.swift", "7AE2DACEA8DF9E797EA241C7", "9D19AFB509CD7DB5C1334F5D"),
    ("InsightsView.swift", "OneFocus/Features/Insights/Views/InsightsView.swift", "31E81D84A1ED05DCA6F7CF65", "BDF17485770167A5705E5790"),
    ("CalendarHeatmap.swift", "OneFocus/Features/Insights/Components/CalendarHeatmap.swift", "2DB9345192DBDDA0AC1F7937", "92A5F3D1FEE737538DDE518A"),
    ("InsightStatCard.swift", "OneFocus/Features/Insights/Components/InsightStatCard.swift", "65575CF86E90D9244AD29E89", "4DC1AE602BE9248FBFC64FD0"),
    ("SettingsViewModel.swift", "OneFocus/Features/Settings/ViewModels/SettingsViewModel.swift", "4B0CA23702F30B0AD0A790C1", "6835B1FEFDD03373AC29FDF4"),
    ("SettingsView.swift", "OneFocus/Features/Settings/Views/SettingsView.swift", "547FD8DF3AAAE1DB5ED089BD", "38D57A08DD10974669E76FFD"),
    ("SettingRow.swift", "OneFocus/Features/Settings/Components/SettingRow.swift", "255912FE1A344970D12FFF9C", "BDDC54C2CB0CAA433376B433"),
    ("SecondHabitOnboardingFlow.swift", "OneFocus/Features/SecondHabit/Views/SecondHabitOnboardingFlow.swift", "42E58C163FCB76DEDE53C355", "E370B1C66767C376EA9EB232"),
]

def update_project_file(project_path):
    """Update the Xcode project file with new files."""

    with open(project_path, 'r') as f:
        content = f.read()

    # 1. Add PBXBuildFile entries (after existing ones, before /* End PBXBuildFile section */)
    build_file_entries = []
    for filename, path, build_uuid, file_uuid in FILES_TO_ADD:
        entry = f"\t\t{build_uuid} /* {filename} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_uuid} /* {filename} */; }};"
        build_file_entries.append(entry)

    build_file_section = "\n".join(build_file_entries)
    content = content.replace(
        "/* End PBXBuildFile section */",
        f"{build_file_section}\n/* End PBXBuildFile section */"
    )

    # 2. Add PBXFileReference entries
    file_ref_entries = []
    for filename, path, build_uuid, file_uuid in FILES_TO_ADD:
        entry = f"\t\t{file_uuid} /* {filename} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; name = \"{filename}\"; path = \"{path}\"; sourceTree = \"<group>\"; }};"
        file_ref_entries.append(entry)

    file_ref_section = "\n".join(file_ref_entries)
    content = content.replace(
        "/* End PBXFileReference section */",
        f"{file_ref_section}\n/* End PBXFileReference section */"
    )

    # 3. Add to PBXGroup section (add all files to OneFocus group for simplicity)
    group_entries = []
    for filename, path, build_uuid, file_uuid in FILES_TO_ADD:
        group_entries.append(f"\t\t\t\t{file_uuid} /* {filename} */,")

    group_section = "\n".join(group_entries)
    # Add before Info.plist in the OneFocus group
    content = content.replace(
        "\t\t\t\t279AF6B9F5134EE1ABF9EECA /* DataService.swift */,",
        f"\t\t\t\t279AF6B9F5134EE1ABF9EECA /* DataService.swift */,\n{group_section}"
    )

    # 4. Add to PBXSourcesBuildPhase
    sources_entries = []
    for filename, path, build_uuid, file_uuid in FILES_TO_ADD:
        sources_entries.append(f"\t\t\t\t{build_uuid} /* {filename} in Sources */,")

    sources_section = "\n".join(sources_entries)
    content = content.replace(
        "\t\t\t\t82D386F0C79948BBB1686A47 /* DataService.swift in Sources */,",
        f"\t\t\t\t82D386F0C79948BBB1686A47 /* DataService.swift in Sources */,\n{sources_section}"
    )

    # Write updated content
    with open(project_path, 'w') as f:
        f.write(content)

    print(f"✅ Successfully updated {project_path}")
    print(f"✅ Added {len(FILES_TO_ADD)} files to Xcode project")

if __name__ == "__main__":
    project_file = "OneFocus.xcodeproj/project.pbxproj"
    try:
        update_project_file(project_file)
        print("\n🎉 Xcode project updated successfully!")
        print("You can now build the project in Xcode or with:")
        print("  xcodebuild -scheme OneFocus -configuration Debug build")
    except Exception as e:
        print(f"❌ Error: {e}", file=sys.stderr)
        sys.exit(1)
