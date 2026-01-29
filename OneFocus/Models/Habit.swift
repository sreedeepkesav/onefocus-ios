import SwiftData
import Foundation

@Model
final class Habit {
    @Attribute(.unique) var id: UUID
    var name: String
    var typeRaw: String
    var trigger: String
    var triggerTypeRaw: String
    var startValue: Int?
    var targetValue: Int?
    var currentValue: Int?
    var dailyTarget: Int?
    var timedMinutes: Int?
    var createdAt: Date
    var isSecondary: Bool

    var type: HabitType {
        get { HabitType(rawValue: typeRaw) ?? .binary }
        set { typeRaw = newValue.rawValue }
    }

    var triggerType: TriggerType {
        get { TriggerType(rawValue: triggerTypeRaw) ?? .anchor }
        set { triggerTypeRaw = newValue.rawValue }
    }

    init(
        name: String,
        type: HabitType,
        trigger: String,
        triggerType: TriggerType = .anchor,
        isSecondary: Bool = false,
        startValue: Int? = nil,
        targetValue: Int? = nil,
        dailyTarget: Int? = nil,
        timedMinutes: Int? = nil
    ) {
        self.id = UUID()
        self.name = name
        self.typeRaw = type.rawValue
        self.trigger = trigger
        self.triggerTypeRaw = triggerType.rawValue
        self.createdAt = Date()
        self.isSecondary = isSecondary
        self.startValue = startValue
        self.targetValue = targetValue
        self.currentValue = startValue
        self.dailyTarget = dailyTarget
        self.timedMinutes = timedMinutes
    }

    // Display helpers
    var triggerDisplayText: String {
        switch triggerType {
        case .throughout:
            return "Throughout the day"
        case .context:
            return trigger
        case .anchor:
            return "After I \(trigger)"
        }
    }

    var typeIcon: String {
        type.icon
    }

    var typeLabel: String {
        type.label
    }
}
