import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var secondHabitOnboardingComplete = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header with stats
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Today")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.textPrimary)

                        Text(currentDateString)
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                    // Journey progress card
                    if let journey = viewModel.journey {
                        JourneyCard(journey: journey)
                            .padding(.horizontal, 20)
                    }

                    // Primary habit
                    if let habit = viewModel.primaryHabit {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Your Habit")
                                .font(.footnote)
                                .foregroundColor(.textSecondary)
                                .textCase(.uppercase)
                                .tracking(1)
                                .padding(.horizontal, 24)

                            HabitCard(
                                habit: habit,
                                isCompleted: viewModel.isPrimaryCompleted(),
                                onTap: {
                                    viewModel.handleQuickCompletion(for: habit)
                                }
                            )
                            .padding(.horizontal, 20)
                        }
                    }

                    // Second habit (if exists)
                    if let secondHabit = viewModel.secondaryHabit {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Second Habit")
                                .font(.footnote)
                                .foregroundColor(.textSecondary)
                                .textCase(.uppercase)
                                .tracking(1)
                                .padding(.horizontal, 24)
                            
                            HabitCard(
                                habit: secondHabit,
                                isCompleted: viewModel.isSecondaryCompleted(),
                                onTap: {
                                    viewModel.handleQuickCompletion(for: secondHabit)
                                }
                            )
                            .padding(.horizontal, 20)
                        }
                    } else if viewModel.canAddSecondHabit {
                        // Show unlock card at day 21
                        AddSecondHabitCard(onTap: {
                            viewModel.showingAddSecondHabitInfo = true
                            HapticManager.shared.trigger(.light)
                        })
                        .padding(.horizontal, 20)
                    }

                    Spacer(minLength: 100)
                }
                .padding(.bottom, 40)
            }
            .background(Color.bgPrimary)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        viewModel.showingInsights = true
                        HapticManager.shared.trigger(.light)
                    } label: {
                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.accent)
                    }
                    .accessibilityLabel("View insights")
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.showingSettings = true
                        HapticManager.shared.trigger(.light)
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.accent)
                    }
                    .accessibilityLabel("Open settings")
                }
            }
            .onAppear {
                viewModel.loadData()
            }
            .sheet(isPresented: $viewModel.showingMoodBefore) {
                if let habit = viewModel.selectedHabit {
                    MoodBeforeView(
                        habitName: habit.name,
                        onComplete: { mood, notes in
                            viewModel.completeMoodBefore(mood: mood, notes: notes)
                        },
                        onDismiss: {
                            viewModel.showingMoodBefore = false
                        }
                    )
                }
            }
            .sheet(isPresented: $viewModel.showingMoodAfter) {
                if let habit = viewModel.selectedHabit {
                    MoodAfterView(
                        habitName: habit.name,
                        onComplete: { mood, notes in
                            viewModel.completeMoodAfter(mood: mood, notes: notes)
                        }
                    )
                }
            }
            .fullScreenCover(isPresented: $viewModel.showingFocusMode) {
                if let habit = viewModel.selectedHabit {
                    FocusView(
                        habit: habit,
                        onComplete: {
                            viewModel.completeHabit()
                        },
                        onDismiss: {
                            viewModel.showingFocusMode = false
                        }
                    )
                }
            }
            .fullScreenCover(isPresented: $viewModel.showingCelebration) {
                if let journey = viewModel.journey {
                    CelebrationView(
                        day: journey.currentDay,
                        streak: journey.currentStreak,
                        phase: journey.currentPhase,
                        onDismiss: {
                            viewModel.dismissCelebration()
                        }
                    )
                }
            }
            .sheet(isPresented: $viewModel.showingAddSecondHabitInfo) {
                if let journey = viewModel.journey, let habit = viewModel.primaryHabit {
                    AddSecondHabitView(
                        currentDay: journey.currentDay,
                        primaryHabitName: habit.name,
                        onStartOnboarding: {
                            viewModel.startSecondHabitOnboarding()
                        },
                        onDismiss: {
                            viewModel.showingAddSecondHabitInfo = false
                        }
                    )
                }
            }
            .fullScreenCover(isPresented: $viewModel.showingSecondHabitOnboarding) {
                SecondHabitOnboardingFlow(isComplete: $secondHabitOnboardingComplete)
                    .onChange(of: secondHabitOnboardingComplete) { _, newValue in
                        if newValue {
                            viewModel.completeSecondHabitOnboarding()
                            secondHabitOnboardingComplete = false
                        }
                    }
            }
            .sheet(isPresented: $viewModel.showingInsights) {
                InsightsView()
            }
            .sheet(isPresented: $viewModel.showingSettings) {
                SettingsView()
            }
        }
    }

    private var currentDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: Date())
    }
}

struct AddSecondHabitCard: View {
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Text("🎉")
                .font(.system(size: 32))

            Text("You can add a second habit!")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)

            Text("Day 21 unlocked")
                .font(.footnote)
                .foregroundColor(.textSecondary)

            Button(action: onTap) {
                Text("Add Habit")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .background(
                        LinearGradient(
                            colors: [.accent, .accentSecondary],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(14)
            }
        }
        .padding(24)
        .background(Color.bgSecondary)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(style: StrokeStyle(lineWidth: 2, dash: [8, 4]))
                .foregroundColor(.textSecondary.opacity(0.3))
        )
        .cornerRadius(20)
    }
}

#Preview {
    HomeView()
}
