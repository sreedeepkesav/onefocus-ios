import SwiftUI

struct OnboardingContainerView: View {
    @State private var defaultViewModel = OnboardingViewModel()
    @Binding var isOnboardingComplete: Bool
    var viewModel: OnboardingViewModel?

    private var activeViewModel: OnboardingViewModel {
        viewModel ?? defaultViewModel
    }

    var body: some View {
        Group {
            switch activeViewModel.currentStep {
            case 0:
                WelcomeView(onContinue: {
                    activeViewModel.next()
                })

            case 1:
                HabitTypeView(
                    selectedType: Binding(
                        get: { activeViewModel.selectedType },
                        set: { activeViewModel.selectedType = $0 }
                    ),
                    onContinue: {
                        activeViewModel.next()
                    },
                    onBack: {
                        activeViewModel.back()
                    }
                )

            case 2:
                HabitNameView(
                    habitType: activeViewModel.selectedType ?? .binary,
                    habitName: Binding(
                        get: { activeViewModel.habitName },
                        set: { activeViewModel.habitName = $0 }
                    ),
                    placeholder: activeViewModel.placeholder(for: activeViewModel.selectedType ?? .binary),
                    onContinue: {
                        activeViewModel.next()
                    },
                    onBack: {
                        activeViewModel.back()
                    }
                )

            case 3:
                if activeViewModel.selectedType == .repeating {
                    // Optional trigger for repeating
                    TriggerRepeatingView(
                        triggerType: Binding(
                            get: { activeViewModel.triggerType },
                            set: { activeViewModel.triggerType = $0 }
                        ),
                        trigger: Binding(
                            get: { activeViewModel.trigger },
                            set: { activeViewModel.trigger = $0 }
                        ),
                        onContinue: {
                            activeViewModel.next()
                        },
                        onBack: {
                            activeViewModel.back()
                        }
                    )
                } else {
                    // Required trigger for others
                    TriggerSetupView(
                        habitName: activeViewModel.habitName,
                        trigger: Binding(
                            get: { activeViewModel.trigger },
                            set: { activeViewModel.trigger = $0 }
                        ),
                        onContinue: {
                            activeViewModel.next()
                        },
                        onBack: {
                            activeViewModel.back()
                        }
                    )
                }

            case 4:
                ReadyView(
                    habitName: activeViewModel.habitName,
                    habitType: activeViewModel.selectedType ?? .binary,
                    trigger: activeViewModel.trigger,
                    triggerType: activeViewModel.triggerType,
                    onStart: {
                        Task {
                            await activeViewModel.complete()
                            isOnboardingComplete = true
                        }
                    },
                    onBack: {
                        activeViewModel.back()
                    }
                )

            default:
                WelcomeView(onContinue: {
                    activeViewModel.next()
                })
            }
        }
        .animation(.easeInOut(duration: 0.3), value: activeViewModel.currentStep)
    }
}
