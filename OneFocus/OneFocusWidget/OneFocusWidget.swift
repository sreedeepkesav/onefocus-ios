import WidgetKit
import SwiftUI
import SwiftData

struct OneFocusWidgetProvider: TimelineProvider {
    let dataService = DataService.shared
    
    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry(
            date: Date(),
            habitName: "Morning Meditation",
            dayNumber: 15,
            isCompleted: false,
            trigger: "After I wake up",
            progress: 15.0 / 66.0,
            currentStreak: 12
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> Void) {
        let entry = makeEntry()
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetEntry>) -> Void) {
        let entry = makeEntry()
        
        // Update widget at midnight
        let calendar = Calendar.current
        let tomorrow = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date())!)
        
        let timeline = Timeline(entries: [entry], policy: .after(tomorrow))
        completion(timeline)
    }
    
    private func makeEntry() -> WidgetEntry {
        let journey = dataService.getOrCreateJourney()
        let habit = dataService.getPrimaryHabit()
        
        return WidgetEntry(
            date: Date(),
            habitName: habit?.name ?? "Your Habit",
            dayNumber: journey.currentDay,
            isCompleted: journey.isCompletedToday(),
            trigger: habit?.triggerDisplayText ?? "",
            progress: journey.progress,
            currentStreak: journey.currentStreak
        )
    }
}

struct WidgetEntry: TimelineEntry {
    let date: Date
    let habitName: String
    let dayNumber: Int
    let isCompleted: Bool
    let trigger: String
    let progress: Double
    let currentStreak: Int
}

// MARK: - Small Widget (170x170pt)

struct SmallWidgetView: View {
    let entry: WidgetEntry
    
    var body: some View {
        ZStack {
            Color.bgPrimary
            
            VStack(spacing: 8) {
                HStack {
                    Text("Day \(entry.dayNumber)")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.textSecondary)
                    
                    Spacer()
                    
                    if entry.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(.success)
                    }
                }
                
                Spacer()
                
                Text(entry.habitName)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.bgTertiary, lineWidth: 6)
                    
                    Circle()
                        .trim(from: 0, to: entry.progress)
                        .stroke(
                            LinearGradient(
                                colors: [.accent, .accentSecondary],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(Int(entry.progress * 100))%")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(.textPrimary)
                }
                .frame(width: 60, height: 60)
            }
            .padding(16)
        }
        .widgetURL(URL(string: "onefocus://home"))
    }
}

// MARK: - Medium Widget (360x170pt)

struct MediumWidgetView: View {
    let entry: WidgetEntry
    
    var body: some View {
        ZStack {
            Color.bgPrimary
            
            HStack(spacing: 16) {
                // Left side - Progress Ring
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .stroke(Color.bgTertiary, lineWidth: 8)
                        
                        Circle()
                            .trim(from: 0, to: entry.progress)
                            .stroke(
                                LinearGradient(
                                    colors: [.accent, .accentSecondary],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 8, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                        
                        VStack(spacing: 2) {
                            Text("Day")
                                .font(.system(size: 11))
                                .foregroundStyle(.textSecondary)
                            
                            Text("\(entry.dayNumber)")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundStyle(.textPrimary)
                            
                            Text("of 66")
                                .font(.system(size: 11))
                                .foregroundStyle(.textSecondary)
                        }
                    }
                    .frame(width: 90, height: 90)
                    
                    if entry.isCompleted {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 12))
                            Text("Complete")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .foregroundStyle(.success)
                    }
                }
                .frame(width: 110)
                
                // Right side - Details
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(entry.habitName)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.textPrimary)
                            .lineLimit(2)
                        
                        Text(entry.trigger)
                            .font(.system(size: 13))
                            .foregroundStyle(.textSecondary)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 16) {
                        StatBadge(
                            icon: "flame.fill",
                            value: "\(entry.currentStreak)",
                            label: "Streak"
                        )
                        
                        StatBadge(
                            icon: "chart.line.uptrend.xyaxis",
                            value: "\(Int(entry.progress * 100))%",
                            label: "Progress"
                        )
                    }
                }
                
                Spacer()
            }
            .padding(16)
        }
        .widgetURL(URL(string: "onefocus://focus"))
    }
}

struct StatBadge: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10))
                .foregroundStyle(.accent)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(value)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(.textPrimary)
                
                Text(label)
                    .font(.system(size: 9))
                    .foregroundStyle(.textSecondary)
            }
        }
    }
}

// MARK: - Widget Configuration

struct OneFocusWidget: Widget {
    let kind: String = "OneFocusWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: OneFocusWidgetProvider()) { entry in
            if #available(iOS 17.0, *) {
                OneFocusWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                OneFocusWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("OneFocus")
        .description("Track your habit journey at a glance")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct OneFocusWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    let entry: WidgetEntry
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

#Preview(as: .systemSmall) {
    OneFocusWidget()
} timeline: {
    WidgetEntry(
        date: Date(),
        habitName: "Morning Meditation",
        dayNumber: 15,
        isCompleted: false,
        trigger: "After I wake up",
        progress: 0.23,
        currentStreak: 12
    )
    WidgetEntry(
        date: Date(),
        habitName: "Daily Reading",
        dayNumber: 42,
        isCompleted: true,
        trigger: "Before bed",
        progress: 0.64,
        currentStreak: 35
    )
}

#Preview(as: .systemMedium) {
    OneFocusWidget()
} timeline: {
    WidgetEntry(
        date: Date(),
        habitName: "Morning Meditation",
        dayNumber: 15,
        isCompleted: false,
        trigger: "After I wake up",
        progress: 0.23,
        currentStreak: 12
    )
}
