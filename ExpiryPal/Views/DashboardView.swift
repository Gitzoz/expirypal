import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel: DashboardViewModel

    init(viewModel: DashboardViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
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
            .onAppear {
                viewModel.load()
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
