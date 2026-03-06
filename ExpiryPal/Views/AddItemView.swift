import SwiftUI

struct AddItemView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AddItemViewModel
    private let isScreenshotMode: Bool

    init(viewModel: AddItemViewModel, isScreenshotMode: Bool = false) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.isScreenshotMode = isScreenshotMode
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("addItem.field.name", text: $viewModel.name)
                        .textInputAutocapitalization(.words)
                        .accessibilityIdentifier("addItem.nameField")
                        .listRowBackground(AppTheme.sandStrong)

                    DatePicker(
                        "addItem.field.expiryDate",
                        selection: $viewModel.expiryDate,
                        displayedComponents: .date
                    )
                    .accessibilityIdentifier("addItem.expiryDateField")
                    .listRowBackground(AppTheme.sandStrong)

                    Picker("addItem.field.location", selection: $viewModel.location) {
                        Text("location.fridge").tag(StorageLocation.fridge)
                        Text("location.freezer").tag(StorageLocation.freezer)
                        Text("location.pantry").tag(StorageLocation.pantry)
                    }
                    .accessibilityIdentifier("addItem.locationPicker")
                    .listRowBackground(AppTheme.sandStrong)

                    TextField("addItem.field.quantity", text: $viewModel.quantityText)
                        .keyboardType(.decimalPad)
                        .accessibilityIdentifier("addItem.quantityField")
                        .listRowBackground(AppTheme.sandStrong)

                    TextField("addItem.field.note", text: $viewModel.note, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                        .accessibilityIdentifier("addItem.noteField")
                        .listRowBackground(AppTheme.sandStrong)
                } footer: {
                    if let validationMessageKey = viewModel.validationMessageKey {
                        Text(LocalizedStringKey(validationMessageKey))
                            .foregroundStyle(AppTheme.rose)
                    }
                }
            }
            .expiryPalScreenChrome()
            .navigationTitle("addItem.title")
            .screenshotModeNavigationTitle("addItem.title", isEnabled: isScreenshotMode)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("addItem.action.cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("addItem.action.save") {
                        viewModel.save()
                    }
                    .accessibilityIdentifier("addItem.saveButton")
                }
            }
            .onChange(of: viewModel.didSave) { _, didSave in
                if didSave {
                    dismiss()
                }
            }
        }
    }
}
