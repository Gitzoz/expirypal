import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel
    private let isScreenshotMode: Bool

    init(viewModel: SettingsViewModel, isScreenshotMode: Bool = false) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.isScreenshotMode = isScreenshotMode
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle("settings.field.notificationsEnabled", isOn: $viewModel.notificationsEnabled)
                        .accessibilityIdentifier("settings.notificationsEnabledToggle")
                        .listRowBackground(AppTheme.sandStrong)

                    Stepper(value: $viewModel.notifyDaysBefore, in: 1...30) {
                        Text(String(format: NSLocalizedString("settings.field.notifyDaysBefore", comment: ""), viewModel.notifyDaysBefore))
                    }
                    .accessibilityLabel(
                        Text(
                            String(
                                format: NSLocalizedString("settings.field.notifyDaysBefore", comment: ""),
                                viewModel.notifyDaysBefore
                            )
                        )
                    )
                    .accessibilityIdentifier("settings.notifyDaysBeforeStepper")
                    .listRowBackground(AppTheme.sandStrong)

                    Toggle("settings.field.notifyOneDayBefore", isOn: $viewModel.notifyOneDayBefore)
                        .disabled(!viewModel.notificationsEnabled)
                        .accessibilityIdentifier("settings.notifyOneDayBeforeToggle")
                        .listRowBackground(AppTheme.sandStrong)

                    Toggle("settings.field.notifyOnDay", isOn: $viewModel.notifyOnDay)
                        .disabled(!viewModel.notificationsEnabled)
                        .accessibilityIdentifier("settings.notifyOnDayToggle")
                        .listRowBackground(AppTheme.sandStrong)

                    DatePicker(
                        "settings.field.notificationTime",
                        selection: $viewModel.notificationTime,
                        displayedComponents: .hourAndMinute
                    )
                    .disabled(!viewModel.notificationsEnabled)
                    .accessibilityIdentifier("settings.notificationTimePicker")
                    .listRowBackground(AppTheme.sandStrong)
                } header: {
                    Text("settings.section.notifications")
                } footer: {
                    if let validationMessageKey = viewModel.validationMessageKey {
                        Text(LocalizedStringKey(validationMessageKey))
                            .foregroundStyle(AppTheme.rose)
                    } else {
                        Text("settings.footer.localOnly")
                            .foregroundStyle(AppTheme.evergreen)
                    }
                }
            }
            .expiryPalScreenChrome()
            .navigationTitle("settings.title")
            .screenshotModeNavigationTitle("settings.title", isEnabled: isScreenshotMode)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("settings.action.save") {
                        viewModel.save()
                    }
                    .accessibilityIdentifier("settings.saveButton")
                }
            }
            .onAppear {
                viewModel.load()
            }
        }
    }
}
