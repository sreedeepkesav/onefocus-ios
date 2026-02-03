import SwiftUI

extension Color {
    // Primary
    static let accent = Color(hex: "BF5AF2")
    static let accentSecondary = Color(hex: "5E5CE6")
    static let accentDim = Color(hex: "BF5AF2").opacity(0.15)
    static let accentGlow = Color(hex: "BF5AF2").opacity(0.4)

    // Backgrounds
    static let bgPrimary = Color.black
    static let bgSecondary = Color(hex: "1C1C1E")
    static let bgTertiary = Color(hex: "2C2C2E")

    // Text
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.6)
    static let textTertiary = Color.white.opacity(0.3)

    // Semantic
    static let success = Color(hex: "30D158")
    static let warning = Color(hex: "FFD60A")
    static let error = Color(hex: "FF453A")

    // Mood colors
    static let mood1 = Color(hex: "FF453A")
    static let mood2 = Color(hex: "FF9F0A")
    static let mood3 = Color(hex: "FFD60A")
    static let mood4 = Color(hex: "30D158")
    static let mood5 = Color(hex: "64D2FF")

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
