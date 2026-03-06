import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel: DashboardViewModel
    @State private var isPresentingAddItem = false
    @State private var selectedItem: FoodItem?
    private let makeAddItemViewModel: () -> AddItemViewModel
    private let makeEditItemViewModel: (FoodItem) -> EditItemViewModel

    init(
        viewModel: DashboardViewModel,
        makeAddItemViewModel: @escaping () -> AddItemViewModel,
        makeEditItemViewModel: @escaping (FoodItem) -> EditItemViewModel
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.makeAddItemViewModel = makeAddItemViewModel
        self.makeEditItemViewModel = makeEditItemViewModel
    }

    var body: some View {
        NavigationStack {
            List {
                if viewModel.allActiveItems.isEmpty {
                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("dashboard.empty.title")
                                .font(.headline)
                            Text("dashboard.empty.message")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                } else {
                    dashboardSection(titleKey: "dashboard.section.today", items: viewModel.todayItems)
                    dashboardSection(titleKey: "dashboard.section.next3days", items: viewModel.next3DaysItems)
                    dashboardSection(titleKey: "dashboard.section.later", items: viewModel.laterItems)
                }
            }
            .navigationTitle("dashboard.title")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isPresentingAddItem = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityIdentifier("dashboard.addButton")
                    .accessibilityLabel(Text("dashboard.action.add_item"))
                }
            }
            .onAppear {
                viewModel.load()
            }
            .sheet(isPresented: $isPresentingAddItem, onDismiss: {
                viewModel.load()
            }) {
                AddItemView(viewModel: makeAddItemViewModel())
            }
            .sheet(item: $selectedItem, onDismiss: {
                viewModel.load()
            }) { item in
                EditItemView(viewModel: makeEditItemViewModel(item))
            }
        }
    }

    @ViewBuilder
    private func dashboardSection(titleKey: LocalizedStringKey, items: [FoodItem]) -> some View {
        if !items.isEmpty {
            Section(header: Text(titleKey)) {
                ForEach(items) { item in
                    Button {
                        selectedItem = item
                    } label: {
                        DashboardRowView(item: item)
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("dashboard.row.\(item.id.uuidString)")
                    .swipeActions(edge: .trailing) {
                        Button("dashboard.action.discard") {
                            viewModel.markDiscarded(id: item.id)
                        }
                        .tint(.red)

                        Button("dashboard.action.consume") {
                            viewModel.markConsumed(id: item.id)
                        }
                        .tint(.green)
                    }
                }
            }
        }
    }
}

private struct DashboardRowView: View {
    let item: FoodItem

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(verbatim: item.name)
                .font(.headline)
            Text(dateText)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var dateText: String {
        item.expiryDate.formatted(date: .abbreviated, time: .omitted)
    }
}
