import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Spacer()

            VStack(spacing: 16) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.accent)

                Text("Home Screen")
                    .font(.title1)
                    .fontWeight(.semibold)

                Text("Coming in Phase 2")
                    .font(.body)
                    .foregroundColor(.textSecondary)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgPrimary)
    }
}

#Preview {
    HomeView()
}
