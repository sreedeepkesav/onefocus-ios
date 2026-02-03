import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = SettingsViewModel()
    @State private var showTimePicker = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.bgPrimary.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Notifications Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Notifications")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.textSecondary)
                                .textCase(.uppercase)
                                .padding(.horizontal, 16)
                            
                            VStack(spacing: 8) {
                                SettingToggleRow(
                                    icon: "bell.fill",
                                    title: "Daily Reminders",
                                    subtitle: "Get reminded to complete your habit",
                                    iconColor: .accent,
                                    isOn: $viewModel.notificationsEnabled
                                )
                                
                                if viewModel.notificationsEnabled {
                                    SettingRow(
                                        icon: "clock.fill",
                                        title: "Reminder Time",
                                        subtitle: viewModel.notificationTime.formatted(date: .omitted, time: .shortened),
                                        iconColor: .accentSecondary,
                                        action: {
                                            showTimePicker = true
                                            HapticManager.shared.trigger(.light)
                                        }
                                    )
                                    
                                    SettingToggleRow(
                                        icon: "speaker.wave.2.fill",
                                        title: "Sound",
                                        subtitle: "Play sound with notifications",
                                        iconColor: .accent,
                                        isOn: $viewModel.notificationSound
                                    )
                                    
                                    SettingToggleRow(
                                        icon: "app.badge.fill",
                                        title: "Badge",
                                        subtitle: "Show badge on app icon",
                                        iconColor: .accent,
                                        isOn: $viewModel.badgeEnabled
                                    )
                                }
                            }
                        }
                        
                        // Habits Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Habits")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.textSecondary)
                                .textCase(.uppercase)
                                .padding(.horizontal, 16)
                            
                            VStack(spacing: 8) {
                                SettingRow(
                                    icon: "arrow.counterclockwise",
                                    title: "Reset Journey",
                                    subtitle: "Start your 66-day journey over",
                                    iconColor: .warning,
                                    action: {
                                        viewModel.showResetAlert = true
                                        HapticManager.shared.trigger(.warning)
                                    }
                                )
                            }
                        }
                        
                        // Data & Privacy Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Data & Privacy")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.textSecondary)
                                .textCase(.uppercase)
                                .padding(.horizontal, 16)
                            
                            VStack(spacing: 8) {
                                SettingRow(
                                    icon: "square.and.arrow.up",
                                    title: "Export Data",
                                    subtitle: "Download your journey data",
                                    iconColor: .accentSecondary,
                                    action: {
                                        viewModel.showExportSheet = true
                                        HapticManager.shared.trigger(.light)
                                    }
                                )
                                
                                SettingRow(
                                    icon: "trash.fill",
                                    title: "Delete All Data",
                                    subtitle: "Permanently delete all data",
                                    iconColor: .error,
                                    action: {
                                        viewModel.showDeleteAlert = true
                                        HapticManager.shared.trigger(.warning)
                                    }
                                )
                            }
                        }
                        
                        // About Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("About")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.textSecondary)
                                .textCase(.uppercase)
                                .padding(.horizontal, 16)
                            
                            VStack(spacing: 8) {
                                SettingRow(
                                    icon: "info.circle.fill",
                                    title: "Version",
                                    subtitle: "1.0.0",
                                    iconColor: .accentSecondary,
                                    action: {}
                                )
                                
                                SettingRow(
                                    icon: "heart.fill",
                                    title: "Made with Love",
                                    subtitle: "Built for habit transformation",
                                    iconColor: .accent,
                                    action: {}
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                        HapticManager.shared.trigger(.light)
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.textSecondary)
                            .symbolRenderingMode(.hierarchical)
                    }
                }
            }
            .sheet(isPresented: $showTimePicker) {
                TimePickerSheet(selectedTime: $viewModel.notificationTime)
                    .presentationDetents([.height(320)])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $viewModel.showExportSheet) {
                ExportDataSheet(data: viewModel.exportData())
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .alert("Reset Journey?", isPresented: $viewModel.showResetAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive) {
                    viewModel.resetJourney()
                }
            } message: {
                Text("This will restart your 66-day journey from day 1. Your habit configuration will be preserved, but all progress will be cleared.")
            }
            .alert("Delete All Data?", isPresented: $viewModel.showDeleteAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    viewModel.deleteAllData()
                    dismiss()
                }
            } message: {
                Text("This will permanently delete all your data including habits, progress, and settings. This action cannot be undone.")
            }
        }
    }
}

struct TimePickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedTime: Date
    
    var body: some View {
        ZStack {
            Color.bgPrimary.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Reminder Time")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.textPrimary)
                    .padding(.top, 20)
                
                DatePicker(
                    "",
                    selection: $selectedTime,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .colorScheme(.dark)
                
                Button {
                    dismiss()
                    HapticManager.shared.trigger(.light)
                } label: {
                    Text("Done")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
    }
}

struct ExportDataSheet: View {
    @Environment(\.dismiss) private var dismiss
    let data: String
    @State private var showShareSheet = false
    
    var body: some View {
        ZStack {
            Color.bgPrimary.ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Text("Export Data")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                        HapticManager.shared.trigger(.light)
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.textSecondary)
                            .symbolRenderingMode(.hierarchical)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                ScrollView {
                    Text(data)
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundColor(.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background(Color.bgSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal, 20)
                }
                
                Button {
                    showShareSheet = true
                    HapticManager.shared.trigger(.light)
                } label: {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share")
                    }
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Color.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: [data])
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    SettingsView()
}
