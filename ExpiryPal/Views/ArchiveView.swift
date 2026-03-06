import SwiftUI

struct ArchiveView: View {
    @StateObject private var viewModel: ArchiveViewModel
    @State private var selectedItem: FoodItem?
    private let makeEditItemViewModel: (FoodItem) -> EditItemViewModel

    init(viewModel: ArchiveViewModel, makeEditItemViewModel: @escaping (FoodItem) -> EditItemViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.makeEditItemViewModel = makeEditItemViewModel
    }

    var body: some View {
        NavigationStack {
            List {
                if viewModel.archivedItems.isEmpty {
                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("archive.empty.title")
                                .font(.headline)
                            Text("archive.empty.message")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                } else {
                    Section {
                        ForEach(viewModel.archivedItems) { item in
                            Button {
                                selectedItem = item
                            } label: {
                                ArchiveRowView(item: item)
                            }
                            .buttonStyle(.plain)
                            .accessibilityIdentifier("archive.row.\(item.id.uuidString)")
                        }
                    }
                }
            }
            .navigationTitle("archive.title")
            .onAppear {
                viewModel.load()
            }
            .sheet(item: $selectedItem, onDismiss: {
                viewModel.load()
            }) { item in
                EditItemView(viewModel: makeEditItemViewModel(item))
            }
        }
    }
}

private struct ArchiveRowView: View {
    let item: FoodItem

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(verbatim: item.name)
                .font(.headline)
            HStack(spacing: 8) {
                Text(item.status == .consumed ? "archive.status.consumed" : "archive.status.discarded")
                Text(LocalizedStringKey("location.\(item.location.rawValue)"))
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)

            Text(item.expiryDate.formatted(date: .abbreviated, time: .omitted))
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
    }
}
