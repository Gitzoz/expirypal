import SwiftUI

struct EditItemView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: EditItemViewModel

    init(viewModel: EditItemViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("editItem.field.name", text: $viewModel.name)
                        .accessibilityIdentifier("editItem.nameField")

                    DatePicker(
                        "editItem.field.expiryDate",
                        selection: $viewModel.expiryDate,
                        displayedComponents: .date
                    )
                    .accessibilityIdentifier("editItem.expiryDateField")

                    Picker("editItem.field.location", selection: $viewModel.location) {
                        Text("location.fridge").tag(StorageLocation.fridge)
                        Text("location.freezer").tag(StorageLocation.freezer)
                        Text("location.pantry").tag(StorageLocation.pantry)
                    }
                    .accessibilityIdentifier("editItem.locationPicker")

                    TextField("editItem.field.quantity", text: $viewModel.quantityText)
                        .keyboardType(.decimalPad)
                        .accessibilityIdentifier("editItem.quantityField")

                    TextField("editItem.field.note", text: $viewModel.note, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                        .accessibilityIdentifier("editItem.noteField")
                } footer: {
                    if let validationMessageKey = viewModel.validationMessageKey {
                        Text(LocalizedStringKey(validationMessageKey))
                            .foregroundStyle(.red)
                    }
                }

                Section("editItem.section.status") {
                    Button("editItem.action.markConsumed") {
                        viewModel.markConsumed()
                    }
                    .accessibilityIdentifier("editItem.markConsumedButton")

                    Button("editItem.action.markDiscarded") {
                        viewModel.markDiscarded()
                    }
                    .accessibilityIdentifier("editItem.markDiscardedButton")
                }
            }
            .navigationTitle("editItem.title")
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
