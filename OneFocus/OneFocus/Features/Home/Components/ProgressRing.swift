import SwiftUI

struct ProgressRing: View {
    let progress: Double
    let lineWidth: CGFloat = 6

    var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(Color.bgTertiary, lineWidth: lineWidth)

            // Progress ring
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    LinearGradient(
                        colors: [.accent, .success],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 1.0), value: progress)
        }
    }
}

#Preview {
    ProgressRing(progress: 0.45)
        .frame(width: 80, height: 80)
        .padding()
        .background(Color.bgPrimary)
}
