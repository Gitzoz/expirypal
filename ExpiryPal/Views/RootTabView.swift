import SwiftUI

enum AppTheme {
    static let evergreenDeep = Color(red: 0.12, green: 0.31, blue: 0.25)
    static let evergreen = Color(red: 0.20, green: 0.47, blue: 0.38)
    static let evergreenSoft = Color(red: 0.27, green: 0.54, blue: 0.44)
    static let sand = Color(red: 0.95, green: 0.93, blue: 0.89)
    static let sandStrong = Color(red: 0.98, green: 0.97, blue: 0.94)
    static let amber = Color(red: 0.89, green: 0.58, blue: 0.25)
    static let amberSoft = Color(red: 0.97, green: 0.90, blue: 0.79)
    static let rose = Color(red: 0.71, green: 0.31, blue: 0.28)
    static let border = evergreenDeep.opacity(0.09)
    static let cardShadow = evergreenDeep.opacity(0.08)
    static let background = LinearGradient(
        colors: [
            Color(red: 0.98, green: 0.96, blue: 0.91),
            sand,
            Color(red: 0.94, green: 0.92, blue: 0.87)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

private struct ExpiryPalScreenModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scrollContentBackground(.hidden)
            .background(AppTheme.background.ignoresSafeArea())
            .toolbarBackground(AppTheme.sandStrong.opacity(0.98), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
    }
}

private struct ExpiryPalCardModifier: ViewModifier {
    let fill: Color
    let border: Color

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(fill)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(border, lineWidth: 1)
            )
            .shadow(color: AppTheme.cardShadow, radius: 18, y: 10)
    }
}

extension View {
    func expiryPalScreenChrome() -> some View {
        modifier(ExpiryPalScreenModifier())
    }

    func expiryPalCard(fill: Color = AppTheme.sandStrong, border: Color = AppTheme.border) -> some View {
        modifier(ExpiryPalCardModifier(fill: fill, border: border))
    }

    @ViewBuilder
    func screenshotModeNavigationTitle(_ titleKey: LocalizedStringKey, isEnabled: Bool) -> some View {
        if isEnabled {
            self
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(titleKey)
                            .font(.system(.headline, design: .rounded).weight(.bold))
                            .foregroundStyle(AppTheme.evergreenDeep)
                            .accessibilityIdentifier("screenshot.mode.title")
                    }
                }
        } else {
            self
        }
    }
}

extension StorageLocation {
    var localizedKey: LocalizedStringKey {
        switch self {
        case .fridge:
            "location.fridge"
        case .freezer:
            "location.freezer"
        case .pantry:
            "location.pantry"
        }
    }
}

struct ExpiryPalPill<Label: View>: View {
    let fill: Color
    let foreground: Color
    let label: Label

    init(fill: Color, foreground: Color = AppTheme.evergreenDeep, @ViewBuilder label: () -> Label) {
        self.fill = fill
        self.foreground = foreground
        self.label = label()
    }

    var body: some View {
        label
            .font(.caption.weight(.semibold))
            .foregroundStyle(foreground)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule(style: .continuous)
                    .fill(fill)
            )
    }
}

private enum RootTabSelection: Hashable {
    case dashboard
    case archive
    case settings
}

struct RootTabView: View {
    let dashboardViewModel: DashboardViewModel
    let archiveViewModel: ArchiveViewModel
    let settingsViewModel: SettingsViewModel
    let makeAddItemViewModel: () -> AddItemViewModel
    let makeEditItemViewModel: (FoodItem) -> EditItemViewModel
    let screenshotScene: ScreenshotScene?

    @State private var selection: RootTabSelection

    init(
        dashboardViewModel: DashboardViewModel,
        archiveViewModel: ArchiveViewModel,
        settingsViewModel: SettingsViewModel,
        makeAddItemViewModel: @escaping () -> AddItemViewModel,
        makeEditItemViewModel: @escaping (FoodItem) -> EditItemViewModel,
        screenshotScene: ScreenshotScene? = nil
    ) {
        self.dashboardViewModel = dashboardViewModel
        self.archiveViewModel = archiveViewModel
        self.settingsViewModel = settingsViewModel
        self.makeAddItemViewModel = makeAddItemViewModel
        self.makeEditItemViewModel = makeEditItemViewModel
        self.screenshotScene = screenshotScene
        _selection = State(initialValue: Self.initialSelection(for: screenshotScene))
    }

    var body: some View {
        TabView(selection: $selection) {
            DashboardView(
                viewModel: dashboardViewModel,
                makeAddItemViewModel: makeAddItemViewModel,
                makeEditItemViewModel: makeEditItemViewModel,
                screenshotScene: screenshotScene
            )
            .tag(RootTabSelection.dashboard)
            .tabItem {
                Label("tab.dashboard", systemImage: "list.bullet.rectangle")
            }

            ArchiveView(
                viewModel: archiveViewModel,
                makeEditItemViewModel: makeEditItemViewModel,
                isScreenshotMode: screenshotScene == .archive
            )
            .tag(RootTabSelection.archive)
            .tabItem {
                Label("tab.archive", systemImage: "archivebox")
            }

            SettingsView(
                viewModel: settingsViewModel,
                isScreenshotMode: screenshotScene == .settings
            )
                .tag(RootTabSelection.settings)
                .tabItem {
                    Label("tab.settings", systemImage: "gearshape")
                }
        }
        .tint(AppTheme.amber)
        .toolbarBackground(AppTheme.sandStrong.opacity(0.98), for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .background(AppTheme.background.ignoresSafeArea())
    }

    private static func initialSelection(for screenshotScene: ScreenshotScene?) -> RootTabSelection {
        switch screenshotScene {
        case .archive:
            .archive
        case .settings:
            .settings
        default:
            .dashboard
        }
    }
}
