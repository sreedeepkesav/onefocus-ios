import SwiftUI

struct SecondHabitOnboardingFlow: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: OnboardingViewModel
    @Binding var isComplete: Bool
    
    init(isComplete: Binding<Bool>) {
        self._isComplete = isComplete
        self._viewModel = State(initialValue: OnboardingViewModel(isSecondary: true))
    }
    
    var body: some View {
        OnboardingContainerView(
            isOnboardingComplete: $isComplete,
            viewModel: viewModel
        )
        .onDisappear {
            if isComplete {
                dismiss()
            }
        }
    }
}
