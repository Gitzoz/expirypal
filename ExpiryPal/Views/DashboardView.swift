import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel: DashboardViewModel
    @State private var isPresentingAddItem = false
    private let makeAddItemViewModel: () -> AddItemViewModel

    init(viewModel: DashboardViewModel, makeAddItemViewModel: @escaping () -> AddItemViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.makeAddItemViewModel = makeAddItemViewModel
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
                    dashboardSection(titleKey: "dashboard.section.all_active", items: viewModel.allActiveItems)
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
        }
    }

    @ViewBuilder
    private func dashboardSection(titleKey: LocalizedStringKey, items: [FoodItem]) -> some View {
        if !items.isEmpty {
            Section(header: Text(titleKey)) {
                ForEach(items) { item in
                    DashboardRowView(item: item)
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
