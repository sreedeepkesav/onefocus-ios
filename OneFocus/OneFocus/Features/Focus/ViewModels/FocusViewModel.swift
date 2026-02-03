import SwiftUI
import Combine

@Observable
@MainActor
final class FocusViewModel {
    var currentPhase: BreathingPhase = .inhale
    var cycleCount = 0
    var isComplete = false

    private var timer: Timer?
    private let totalCycles = 3 // 3 complete breathing cycles

    func startBreathing() {
        currentPhase = .inhale
        cycleCount = 0
        isComplete = false
        scheduleNextPhase()
    }

    func stopBreathing() {
        timer?.invalidate()
        timer = nil
    }

    private func scheduleNextPhase() {
        timer?.invalidate()

        timer = Timer.scheduledTimer(
            withTimeInterval: currentPhase.duration,
            repeats: false
        ) { [weak self] _ in
            guard let self = self else { return }

            Task { @MainActor in
                self.advancePhase()
            }
        }
    }

    private func advancePhase() {
        // Move to next phase
        currentPhase = currentPhase.next

        // If we completed an exhale, increment cycle count
        if currentPhase == .inhale {
            cycleCount += 1

            if cycleCount >= totalCycles {
                isComplete = true
                timer?.invalidate()
                return
            }
        }

        // Schedule next phase
        scheduleNextPhase()
    }

    func skip() {
        stopBreathing()
        isComplete = true
    }
}
