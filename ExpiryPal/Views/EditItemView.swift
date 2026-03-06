import SwiftUI

struct EditItemView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: EditItemViewModel
    private let isScreenshotMode: Bool

    init(viewModel: EditItemViewModel, isScreenshotMode: Bool = false) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.isScreenshotMode = isScreenshotMode
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("editItem.field.name", text: $viewModel.name)
                        .textInputAutocapitalization(.words)
                        .accessibilityIdentifier("editItem.nameField")
                        .listRowBackground(AppTheme.sandStrong)

                    DatePicker(
                        "editItem.field.expiryDate",
                        selection: $viewModel.expiryDate,
                        displayedComponents: .date
                    )
                    .accessibilityIdentifier("editItem.expiryDateField")
                    .listRowBackground(AppTheme.sandStrong)

                    Picker("editItem.field.location", selection: $viewModel.location) {
                        Text("location.fridge").tag(StorageLocation.fridge)
                        Text("location.freezer").tag(StorageLocation.freezer)
                        Text("location.pantry").tag(StorageLocation.pantry)
                    }
                    .accessibilityIdentifier("editItem.locationPicker")
                    .listRowBackground(AppTheme.sandStrong)

                    TextField("editItem.field.quantity", text: $viewModel.quantityText)
                        .keyboardType(.decimalPad)
                        .accessibilityIdentifier("editItem.quantityField")
                        .listRowBackground(AppTheme.sandStrong)

                    TextField("editItem.field.note", text: $viewModel.note, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                        .accessibilityIdentifier("editItem.noteField")
                        .listRowBackground(AppTheme.sandStrong)
                } footer: {
                    if let validationMessageKey = viewModel.validationMessageKey {
                        Text(LocalizedStringKey(validationMessageKey))
                            .foregroundStyle(AppTheme.rose)
                    }
                }

                Section("editItem.section.status") {
                    Button("editItem.action.markConsumed") {
                        viewModel.markConsumed()
                    }
                    .accessibilityIdentifier("editItem.markConsumedButton")
                    .listRowBackground(AppTheme.sandStrong)

                    Button("editItem.action.markDiscarded") {
                        viewModel.markDiscarded()
                    }
                    .accessibilityIdentifier("editItem.markDiscardedButton")
                    .listRowBackground(AppTheme.sandStrong)
                }
            }
            .expiryPalScreenChrome()
            .navigationTitle("editItem.title")
            .screenshotModeNavigationTitle("editItem.title", isEnabled: isScreenshotMode)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("editItem.action.cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("editItem.action.save") {
                        viewModel.save()
                    }
                    .accessibilityIdentifier("editItem.saveButton")
                }
            }
            .onChange(of: viewModel.didSave) { _, didSave in
                if didSave {
                    dismiss()
                }
            }
            .onChange(of: viewModel.didArchive) { _, didArchive in
                if didArchive {
                    dismiss()
                }
            }
        }
    }
}
