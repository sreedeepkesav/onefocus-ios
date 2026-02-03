import SwiftUI
import SwiftData

@main
struct OneFocusApp: App {
    @State private var hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    @State private var deepLinkHandler = DeepLinkHandler()

    var body: some Scene {
        WindowGroup {
            ContentView(
                isOnboardingComplete: $hasCompletedOnboarding,
                deepLinkHandler: deepLinkHandler
            )
            .preferredColorScheme(.dark)
            .onOpenURL { url in
                deepLinkHandler.handle(url)
            }
        }
        .modelContainer(DataService.shared.container)
    }
}

struct ContentView: View {
    @Binding var isOnboardingComplete: Bool
    @Bindable var deepLinkHandler: DeepLinkHandler

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
    ContentView(
        isOnboardingComplete: .constant(false),
        deepLinkHandler: DeepLinkHandler()
    )
    .modelContainer(DataService.shared.container)
}
