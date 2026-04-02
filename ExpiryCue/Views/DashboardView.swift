import SwiftUI

private enum DashboardSectionTone {
    case urgent
    case upcoming
    case calm

    var fill: Color {
        switch self {
        case .urgent:
            AppTheme.amberSoft
        case .upcoming:
            AppTheme.sandStrong
        case .calm:
            Color.white.opacity(0.82)
        }
    }

    var border: Color {
        switch self {
        case .urgent:
            AppTheme.amber.opacity(0.35)
        case .upcoming:
            AppTheme.evergreenSoft.opacity(0.22)
        case .calm:
            AppTheme.border
        }
    }

    var accent: Color {
        switch self {
        case .urgent:
            AppTheme.amber
        case .upcoming:
            AppTheme.evergreenSoft
        case .calm:
            AppTheme.evergreen
        }
    }

    var symbol: String {
        switch self {
        case .urgent:
            "clock.badge.exclamationmark"
        case .upcoming:
            "calendar.badge.clock"
        case .calm:
            "leaf"
        }
    }
}

struct DashboardView: View {
    @StateObject private var viewModel: DashboardViewModel
    @State private var isPresentingAddItem = false
    @State private var selectedItem: FoodItem?
    @State private var hasAppliedScreenshotScene = false
    private let makeAddItemViewModel: () -> AddItemViewModel
    private let makeEditItemViewModel: (FoodItem) -> EditItemViewModel
    private let screenshotScene: ScreenshotScene?

    init(
        viewModel: DashboardViewModel,
        makeAddItemViewModel: @escaping () -> AddItemViewModel,
        makeEditItemViewModel: @escaping (FoodItem) -> EditItemViewModel,
        screenshotScene: ScreenshotScene? = nil
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.makeAddItemViewModel = makeAddItemViewModel
        self.makeEditItemViewModel = makeEditItemViewModel
        self.screenshotScene = screenshotScene
    }

    var body: some View {
        NavigationStack {
            List {
                if viewModel.allActiveItems.isEmpty {
                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("dashboard.empty.title")
                                .font(.headline.weight(.semibold))
                                .foregroundStyle(AppTheme.evergreenDeep)
                            Text("dashboard.empty.message")
                                .font(.subheadline)
                                .foregroundStyle(AppTheme.evergreen)
                        }
                        .padding(20)
                        .expiryPalCard()
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                } else {
                    Section {
                        DashboardOverviewCard(
                            todayCount: viewModel.todayItems.count,
                            next3DaysCount: viewModel.next3DaysItems.count,
                            laterCount: viewModel.laterItems.count
                        )
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)

                    dashboardSection(titleKey: "dashboard.section.today", items: viewModel.todayItems, tone: .urgent)
                    dashboardSection(titleKey: "dashboard.section.next3days", items: viewModel.next3DaysItems, tone: .upcoming)
                    dashboardSection(titleKey: "dashboard.section.later", items: viewModel.laterItems, tone: .calm)
                }
            }
            .listStyle(.plain)
            .expiryPalScreenChrome()
            .expiryCueNavigationTitle("dashboard.title", isScreenshotMode: screenshotScene != nil)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isPresentingAddItem = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.headline.weight(.bold))
                    }
                    .accessibilityIdentifier("dashboard.addButton")
                    .accessibilityLabel(Text("dashboard.action.add_item"))
                }
            }
            .onAppear {
                resetTransientPresentationStateIfNeeded()
                viewModel.load()
                applyScreenshotSceneIfNeeded()
            }
            .sheet(isPresented: $isPresentingAddItem, onDismiss: {
                viewModel.load()
            }) {
                AddItemView(
                    viewModel: makeAddItemViewModel(),
                    isScreenshotMode: screenshotScene == .addItem
                )
            }
            .sheet(item: $selectedItem, onDismiss: {
                viewModel.load()
            }) { item in
                EditItemView(
                    viewModel: makeEditItemViewModel(item),
                    isScreenshotMode: screenshotScene == .editItem
                )
            }
        }
    }

    private func applyScreenshotSceneIfNeeded() {
        guard !hasAppliedScreenshotScene else {
            return
        }

        hasAppliedScreenshotScene = true

        switch screenshotScene {
        case .addItem:
            isPresentingAddItem = true
        case .editItem:
            selectedItem = viewModel.allActiveItems.first {
                $0.name == AppLaunchConfiguration.screenshotEditItemName
            } ?? viewModel.allActiveItems.first
        default:
            break
        }
    }

    private func resetTransientPresentationStateIfNeeded() {
        guard screenshotScene == nil else {
            return
        }

        isPresentingAddItem = false
        selectedItem = nil
        hasAppliedScreenshotScene = false
    }

    @ViewBuilder
    private func dashboardSection(titleKey: LocalizedStringKey, items: [FoodItem], tone: DashboardSectionTone) -> some View {
        if !items.isEmpty {
            Section(header: Text(titleKey)) {
                ForEach(items) { item in
                    Button {
                        selectedItem = item
                    } label: {
                        DashboardRowView(item: item, tone: tone)
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("dashboard.row.\(item.id.uuidString)")
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .swipeActions(edge: .trailing) {
                        Button("dashboard.action.discard") {
                            viewModel.markDiscarded(id: item.id)
                        }
                        .tint(AppTheme.rose)

                        Button("dashboard.action.consume") {
                            viewModel.markConsumed(id: item.id)
                        }
                        .tint(AppTheme.evergreen)
                    }
                }
            }
        }
    }
}

private struct DashboardOverviewCard: View {
    let todayCount: Int
    let next3DaysCount: Int
    let laterCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("dashboard.title")
                .font(.system(.title3, design: .rounded).weight(.bold))
                .foregroundStyle(AppTheme.evergreenDeep)

            HStack(spacing: 10) {
                summaryPill(titleKey: "dashboard.section.today", count: todayCount, fill: AppTheme.amberSoft)
                summaryPill(titleKey: "dashboard.section.next3days", count: next3DaysCount, fill: AppTheme.sandStrong)
                summaryPill(titleKey: "dashboard.section.later", count: laterCount, fill: Color.white.opacity(0.88))
            }
        }
        .padding(20)
        .expiryPalCard()
    }

    private func summaryPill(titleKey: LocalizedStringKey, count: Int, fill: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(count)")
                .font(.system(.title3, design: .rounded).weight(.bold))
            Text(titleKey)
                .font(.caption.weight(.semibold))
        }
        .foregroundStyle(AppTheme.evergreenDeep)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(fill)
        )
    }
}

private struct DashboardRowView: View {
    let item: FoodItem
    let tone: DashboardSectionTone

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(alignment: .leading, spacing: 10) {
                Text(verbatim: item.name)
                    .font(.system(.title3, design: .rounded).weight(.semibold))
                    .foregroundStyle(AppTheme.evergreenDeep)

                ExpiryCuePill(fill: tone.fill, foreground: AppTheme.evergreenDeep) {
                    Text(item.location.localizedKey)
                }
            }

            Spacer(minLength: 12)

            VStack(alignment: .trailing, spacing: 10) {
                Image(systemName: tone.symbol)
                    .font(.headline)
                    .foregroundStyle(tone.accent)

                Text(dateText)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(AppTheme.evergreen)
                    .multilineTextAlignment(.trailing)
            }
        }
        .padding(18)
        .expiryPalCard(fill: tone.fill, border: tone.border)
    }

    private var dateText: String {
        item.expiryDate.formatted(date: .abbreviated, time: .omitted)
    }
}
