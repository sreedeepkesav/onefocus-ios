import SwiftUI

struct OnboardingContainerView: View {
    @State private var viewModel = OnboardingViewModel()
    @Binding var isOnboardingComplete: Bool

    var body: some View {
        Group {
            switch viewModel.currentStep {
            case 0:
                WelcomeView(onContinue: {
                    viewModel.next()
                })

            case 1:
                HabitTypeView(
                    selectedType: $viewModel.selectedType,
                    onContinue: {
                        viewModel.next()
                    },
                    onBack: {
                        viewModel.back()
                    }
                )

            case 2:
                HabitNameView(
                    habitType: viewModel.selectedType ?? .binary,
                    habitName: $viewModel.habitName,
                    placeholder: viewModel.placeholder(for: viewModel.selectedType ?? .binary),
                    onContinue: {
                        viewModel.next()
                    },
                    onBack: {
                        viewModel.back()
                    }
                )

            case 3:
                if viewModel.selectedType == .repeating {
                    // Optional trigger for repeating
                    TriggerRepeatingView(
                        triggerType: $viewModel.triggerType,
                        trigger: $viewModel.trigger,
                        onContinue: {
                            viewModel.next()
                        },
                        onBack: {
                            viewModel.back()
                        }
                    )
                } else {
                    // Required trigger for others
                    TriggerSetupView(
                        habitName: viewModel.habitName,
                        trigger: $viewModel.trigger,
                        onContinue: {
                            viewModel.next()
                        },
                        onBack: {
                            viewModel.back()
                        }
                    )
                }

            case 4:
                ReadyView(
                    habitName: viewModel.habitName,
                    habitType: viewModel.selectedType ?? .binary,
                    trigger: viewModel.trigger,
                    triggerType: viewModel.triggerType,
                    onStart: {
                        Task {
                            await viewModel.complete()
                            isOnboardingComplete = true
                        }
                    },
                    onBack: {
                        viewModel.back()
                    }
                )

            default:
                WelcomeView(onContinue: {
                    viewModel.next()
                })
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.currentStep)
    }
}
