import SwiftUI
import SwiftData

@main
struct OneFocusApp: App {
    @State private var hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")

    var body: some Scene {
        WindowGroup {
            ContentView(isOnboardingComplete: $hasCompletedOnboarding)
                .preferredColorScheme(.dark)
        }
        .modelContainer(DataService.shared.container)
    }
}

struct ContentView: View {
    @Binding var isOnboardingComplete: Bool

    var body: some View {
        ZStack {
            if isOnboardingComplete {
                HomeView()
            } else {
                OnboardingContainerView(isOnboardingComplete: $isOnboardingComplete)
            }
        }
    }
}

#Preview {
    ContentView(isOnboardingComplete: .constant(false))
        .modelContainer(DataService.shared.container)
}
