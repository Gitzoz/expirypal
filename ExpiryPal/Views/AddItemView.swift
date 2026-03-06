import SwiftUI

struct AddItemView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AddItemViewModel

    init(viewModel: AddItemViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("addItem.field.name", text: $viewModel.name)
                        .accessibilityIdentifier("addItem.nameField")

                    DatePicker(
                        "addItem.field.expiryDate",
                        selection: $viewModel.expiryDate,
                        displayedComponents: .date
                    )
                    .accessibilityIdentifier("addItem.expiryDateField")

                    Picker("addItem.field.location", selection: $viewModel.location) {
                        Text("location.fridge").tag(StorageLocation.fridge)
                        Text("location.freezer").tag(StorageLocation.freezer)
                        Text("location.pantry").tag(StorageLocation.pantry)
                    }
                    .accessibilityIdentifier("addItem.locationPicker")

                    TextField("addItem.field.quantity", text: $viewModel.quantityText)
                        .keyboardType(.decimalPad)
                        .accessibilityIdentifier("addItem.quantityField")

                    TextField("addItem.field.note", text: $viewModel.note, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                        .accessibilityIdentifier("addItem.noteField")
                } footer: {
                    if let validationMessageKey = viewModel.validationMessageKey {
                        Text(LocalizedStringKey(validationMessageKey))
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("addItem.title")
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
