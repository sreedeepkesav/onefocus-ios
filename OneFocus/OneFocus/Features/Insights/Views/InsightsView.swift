import SwiftUI

struct InsightsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = InsightsViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.bgPrimary.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Stats Overview
                        VStack(spacing: 12) {
                            InsightStatsRow(stats: [
                                (
                                    icon: "chart.line.uptrend.xyaxis",
                                    title: "Completion Rate",
                                    value: "\(Int(viewModel.completionRate * 100))%",
                                    color: .accent
                                ),
                                (
                                    icon: "flame.fill",
                                    title: "Current Streak",
                                    value: "\(viewModel.currentStreak)",
                                    color: .warning
                                )
                            ])
                            
                            InsightStatsRow(stats: [
                                (
                                    icon: "trophy.fill",
                                    title: "Best Streak",
                                    value: "\(viewModel.bestStreak)",
                                    color: .success
                                ),
                                (
                                    icon: "clock.fill",
                                    title: "Total Focus",
                                    value: viewModel.totalFocusTime,
                                    color: .accentSecondary
                                )
                            ])
                        }
                        
                        // Calendar Heatmap
                        CalendarHeatmap(days: viewModel.heatmapData)
                        
                        // Journey Progress
                        if let journey = viewModel.journey {
                            JourneyProgressCard(journey: journey)
                        }
                        
                        // Habit Details
                        if let habit = viewModel.primaryHabit {
                            HabitDetailsCard(habit: habit, isPrimary: true)
                        }
                        
                        if let habit = viewModel.secondaryHabit {
                            HabitDetailsCard(habit: habit, isPrimary: false)
                        }

                        // Reflections Section
                        if viewModel.hasReflections {
                            ReflectionsHistoryCard(reflections: viewModel.completedReflections)
                        }

                        // Past Journeys Section
                        if viewModel.hasArchivedJourneys {
                            PastJourneysCard(journeys: viewModel.archivedJourneys)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("Insights")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                        HapticManager.shared.trigger(.light)
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.textSecondary)
                            .symbolRenderingMode(.hierarchical)
                    }
                }
            }
            .onAppear {
                viewModel.loadData()
            }
        }
    }
}

struct JourneyProgressCard: View {
    let journey: Journey
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "map.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.accent)
                
                Text("Journey Progress")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.textPrimary)
            }
            
            VStack(spacing: 12) {
                ProgressRow(
                    label: "Current Day",
                    value: "\(journey.currentDay) of 66"
                )
                
                ProgressRow(
                    label: "Phase",
                    value: journey.currentPhase.rawValue
                )
                
                ProgressRow(
                    label: "Days Completed",
                    value: "\(journey.completedDays.count)"
                )
                
                ProgressRow(
                    label: "Flex Days Remaining",
                    value: "\(journey.flexDaysRemaining) of 3"
                )
            }
            .padding(16)
            .background(Color.bgTertiary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(20)
        .background(Color.bgSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct ProgressRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 15))
                .foregroundColor(.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.textPrimary)
        }
    }
}

struct HabitDetailsCard: View {
    let habit: Habit
    let isPrimary: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: habit.typeIcon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(isPrimary ? .accent : .accentSecondary)
                
                Text(isPrimary ? "Primary Habit" : "Secondary Habit")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.textPrimary)
            }
            
            VStack(spacing: 12) {
                ProgressRow(label: "Name", value: habit.name)
                ProgressRow(label: "Type", value: habit.typeLabel)
                ProgressRow(label: "Trigger", value: habit.triggerDisplayText)
                
                if let timedMinutes = habit.timedMinutes {
                    ProgressRow(label: "Duration", value: "\(timedMinutes) min")
                }
                
                if let dailyTarget = habit.dailyTarget {
                    ProgressRow(label: "Daily Target", value: "\(dailyTarget)")
                }
            }
            .padding(16)
            .background(Color.bgTertiary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(20)
        .background(Color.bgSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct ReflectionsHistoryCard: View {
    let reflections: [Reflection]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "book.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.accent)

                Text("Weekly Reflections")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.textPrimary)

                Spacer()

                Text("\(reflections.count)")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.textSecondary)
            }

            if reflections.isEmpty {
                VStack(spacing: 8) {
                    Text("No reflections yet")
                        .font(.body)
                        .foregroundColor(.textSecondary)
                    Text("Complete your first weekly reflection to see insights here")
                        .font(.footnote)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
            } else {
                VStack(spacing: 12) {
                    ForEach(reflections) { reflection in
                        ReflectionSummaryRow(reflection: reflection)
                    }
                }
            }
        }
        .padding(20)
        .background(Color.bgSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct ReflectionSummaryRow: View {
    let reflection: Reflection
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
                HapticManager.shared.trigger(.light)
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(reflection.weekLabel)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.textPrimary)

                        Text(reflection.formattedDate)
                            .font(.system(size: 13))
                            .foregroundColor(.textSecondary)
                    }

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.textSecondary)
                }
            }
            .accessibilityLabel("Reflection for \(reflection.weekLabel)")
            .accessibilityHint(isExpanded ? "Tap to collapse" : "Tap to expand")

            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    if !reflection.whatHelped.isEmpty {
                        ReflectionAnswerView(
                            question: "What helped",
                            answer: reflection.whatHelped,
                            icon: "checkmark.seal.fill"
                        )
                    }

                    if !reflection.whatHindered.isEmpty {
                        ReflectionAnswerView(
                            question: "What was hard",
                            answer: reflection.whatHindered,
                            icon: "exclamationmark.triangle.fill"
                        )
                    }

                    if !reflection.patternsNoticed.isEmpty {
                        ReflectionAnswerView(
                            question: "Patterns noticed",
                            answer: reflection.patternsNoticed,
                            icon: "chart.line.uptrend.xyaxis"
                        )
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(16)
        .background(Color.bgTertiary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct ReflectionAnswerView: View {
    let question: String
    let answer: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.accent)

                Text(question)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.textSecondary)
                    .textCase(.uppercase)
                    .tracking(0.5)
            }

            Text(answer)
                .font(.system(size: 15))
                .foregroundColor(.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct PastJourneysCard: View {
    let journeys: [Journey]
    @State private var selectedJourney: Journey?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.warning)

                Text("Past Journeys")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.textPrimary)

                Spacer()

                Text("\(journeys.count)")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.textSecondary)
            }

            VStack(spacing: 12) {
                ForEach(journeys, id: \.id) { journey in
                    PastJourneyRow(journey: journey) {
                        selectedJourney = journey
                    }
                }
            }
        }
        .padding(20)
        .background(Color.bgSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .sheet(item: $selectedJourney) { journey in
            PastJourneyDetailView(journey: journey)
        }
    }
}

struct PastJourneyRow: View {
    let journey: Journey
    let onTap: () -> Void

    var completionRate: Double {
        let totalCompleted = journey.completedDays.count
        let totalDays = journey.currentDay
        return totalDays > 0 ? Double(totalCompleted) / Double(totalDays) : 0
    }

    var dateRange: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let start = formatter.string(from: journey.startDate)

        if let end = journey.endDate {
            let endStr = formatter.string(from: end)
            return "\(start) - \(endStr)"
        }

        return start
    }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: journey.journeyStatus == .completed ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(journey.journeyStatus == .completed ? .success : .warning)

                        Text(journey.journeyStatus == .completed ? "Completed" : "Learning Experience")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.textPrimary)
                    }

                    Text(dateRange)
                        .font(.system(size: 13))
                        .foregroundColor(.textSecondary)

                    Text("\(journey.completedDays.count) days completed (\(Int(completionRate * 100))%)")
                        .font(.system(size: 13))
                        .foregroundColor(.textSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(.textSecondary)
            }
            .padding(16)
            .background(Color.bgTertiary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}

struct PastJourneyDetailView: View {
    let journey: Journey
    @Environment(\.dismiss) private var dismiss

    var analysisData: FailureAnalysisData? {
        guard let notesJSON = journey.failureAnalysisNotes,
              let data = notesJSON.data(using: .utf8) else {
            return nil
        }

        return try? JSONDecoder().decode(FailureAnalysisData.self, from: data)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Heatmap
                    CompletionHeatmapView(journey: journey)
                        .padding(.horizontal, 20)

                    // Week breakdown
                    WeekBreakdownView(weeklyData: journey.getWeeklyCompletionData())
                        .padding(.horizontal, 20)

                    // Analysis notes (if available)
                    if let analysis = analysisData {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Your Reflections")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.textPrimary)

                            if !analysis.whatWorked.isEmpty {
                                AnalysisNote(
                                    icon: "checkmark.circle.fill",
                                    iconColor: .success,
                                    title: "What worked well",
                                    text: analysis.whatWorked
                                )
                            }

                            if !analysis.whatDidnt.isEmpty {
                                AnalysisNote(
                                    icon: "xmark.circle.fill",
                                    iconColor: .error,
                                    title: "What didn't work",
                                    text: analysis.whatDidnt
                                )
                            }

                            if !analysis.nextTimeChanges.isEmpty {
                                AnalysisNote(
                                    icon: "lightbulb.fill",
                                    iconColor: .warning,
                                    title: "Changes for next time",
                                    text: analysis.nextTimeChanges
                                )
                            }
                        }
                        .padding(20)
                        .background(Color.bgSecondary)
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.vertical, 20)
            }
            .background(Color.bgPrimary)
            .navigationTitle("Journey Review")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.textSecondary)
                    }
                }
            }
        }
    }
}

struct AnalysisNote: View {
    let icon: String
    let iconColor: Color
    let title: String
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.footnote)
                    .foregroundColor(iconColor)

                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.textSecondary)
            }

            Text(text)
                .font(.body)
                .foregroundColor(.textPrimary)
        }
    }
}

#Preview {
    InsightsView()
}
