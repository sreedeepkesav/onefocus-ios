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

#Preview {
    InsightsView()
}
