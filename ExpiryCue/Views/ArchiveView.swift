import SwiftUI

struct ArchiveView: View {
    @StateObject private var viewModel: ArchiveViewModel
    @State private var selectedItem: FoodItem?
    private let makeEditItemViewModel: (FoodItem) -> EditItemViewModel
    private let isScreenshotMode: Bool

    init(
        viewModel: ArchiveViewModel,
        makeEditItemViewModel: @escaping (FoodItem) -> EditItemViewModel,
        isScreenshotMode: Bool = false
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.makeEditItemViewModel = makeEditItemViewModel
        self.isScreenshotMode = isScreenshotMode
    }

    var body: some View {
        NavigationStack {
            List {
                if viewModel.archivedItems.isEmpty {
                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("archive.empty.title")
                                .font(.headline.weight(.semibold))
                                .foregroundStyle(AppTheme.evergreenDeep)
                            Text("archive.empty.message")
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
                        ForEach(viewModel.archivedItems) { item in
                            Button {
                                selectedItem = item
                            } label: {
                                ArchiveRowView(item: item)
                            }
                            .buttonStyle(.plain)
                            .accessibilityIdentifier("archive.row.\(item.id.uuidString)")
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .expiryPalScreenChrome()
            .expiryCueNavigationTitle("archive.title", isScreenshotMode: isScreenshotMode)
            .onAppear {
                viewModel.load()
            }
            .sheet(item: $selectedItem, onDismiss: {
                viewModel.load()
            }) { item in
                EditItemView(viewModel: makeEditItemViewModel(item), isScreenshotMode: false)
            }
        }
    }
}

private struct ArchiveRowView: View {
    let item: FoodItem

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(verbatim: item.name)
                .font(.system(.title3, design: .rounded).weight(.semibold))
                .foregroundStyle(AppTheme.evergreenDeep)
            HStack(spacing: 8) {
                ExpiryCuePill(
                    fill: item.status == .consumed ? AppTheme.sandStrong : AppTheme.amberSoft,
                    foreground: item.status == .consumed ? AppTheme.evergreenDeep : AppTheme.rose
                ) {
                    Text(item.status == .consumed ? "archive.status.consumed" : "archive.status.discarded")
                }

                ExpiryCuePill(fill: Color.white.opacity(0.85)) {
                    Text(item.location.localizedKey)
                }
            }

            Text(item.expiryDate.formatted(date: .abbreviated, time: .omitted))
                .font(.footnote.weight(.semibold))
                .foregroundStyle(AppTheme.evergreen)
        }
        .padding(18)
        .expiryPalCard(fill: AppTheme.sandStrong)
    }
}
