import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel

    init(viewModel: SettingsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle("settings.field.notificationsEnabled", isOn: $viewModel.notificationsEnabled)
                        .accessibilityIdentifier("settings.notificationsEnabledToggle")

                    Stepper(value: $viewModel.notifyDaysBefore, in: 1...30) {
                        Text(String(format: NSLocalizedString("settings.field.notifyDaysBefore", comment: ""), viewModel.notifyDaysBefore))
                    }
                    .accessibilityIdentifier("settings.notifyDaysBeforeStepper")

                    Toggle("settings.field.notifyOneDayBefore", isOn: $viewModel.notifyOneDayBefore)
                        .disabled(!viewModel.notificationsEnabled)
                        .accessibilityIdentifier("settings.notifyOneDayBeforeToggle")

                    Toggle("settings.field.notifyOnDay", isOn: $viewModel.notifyOnDay)
                        .disabled(!viewModel.notificationsEnabled)
                        .accessibilityIdentifier("settings.notifyOnDayToggle")

                    DatePicker(
                        "settings.field.notificationTime",
                        selection: $viewModel.notificationTime,
                        displayedComponents: .hourAndMinute
                    )
                    .disabled(!viewModel.notificationsEnabled)
                    .accessibilityIdentifier("settings.notificationTimePicker")
                } header: {
                    Text("settings.section.notifications")
                } footer: {
                    if let validationMessageKey = viewModel.validationMessageKey {
                        Text(LocalizedStringKey(validationMessageKey))
                            .foregroundStyle(.red)
                    } else {
                        Text("settings.footer.localOnly")
                    }
                }
            }
            .navigationTitle("settings.title")
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
