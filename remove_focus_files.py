#!/usr/bin/env python3
"""
Remove Focus feature files from Xcode project.pbxproj
"""
import re

project_path = "OneFocus/OneFocus.xcodeproj/project.pbxproj"

# Files to remove (from the deleted Focus directory)
FILES_TO_REMOVE = [
    "FocusView.swift",
    "FocusViewModel.swift",
    "BreathingCircle.swift",
    "CelebrationView.swift"
]

with open(project_path, 'r') as f:
    content = f.read()

# Remove lines containing these files
for filename in FILES_TO_REMOVE:
    # Remove any line that references this file
    lines = content.split('\n')
    filtered_lines = [line for line in lines if filename not in line]
    content = '\n'.join(filtered_lines)

with open(project_path, 'w') as f:
    f.write(content)

print(f"✅ Removed {len(FILES_TO_REMOVE)} Focus files from Xcode project")
print("Removed files:", ", ".join(FILES_TO_REMOVE))
