import SwiftUI

enum ScreenshotScene: String {
    case dashboard
    case addItem
    case editItem
    case archive
    case settings
}

struct AppLaunchConfiguration {
    static let screenshotEditItemName = "Greek Yogurt"

    let isUITesting: Bool
    let screenshotScene: ScreenshotScene?

    var usesInMemoryStore: Bool {
        isUITesting || screenshotScene != nil
    }

    static func current(processInfo: ProcessInfo = .processInfo) -> AppLaunchConfiguration {
        from(arguments: processInfo.arguments)
    }

    static func from(arguments: [String]) -> AppLaunchConfiguration {
        let screenshotScene = arguments
            .first { $0.hasPrefix("SCREENSHOT_SCENE=") }
            .flatMap { $0.split(separator: "=", maxSplits: 1).last.map(String.init) }
            .flatMap(ScreenshotScene.init(rawValue:))

        return AppLaunchConfiguration(
            isUITesting: arguments.contains("UITEST_MODE"),
            screenshotScene: arguments.contains("SCREENSHOT_MODE") ? screenshotScene : nil
        )
    }
}

@main
struct ExpiryPalApp: App {
    private let launchConfiguration: AppLaunchConfiguration
    private let container: AppContainer

    init() {
        self.launchConfiguration = AppLaunchConfiguration.current()
        let clock: Clock = launchConfiguration.screenshotScene != nil
            ? FrozenClock(now: Self.screenshotReferenceDate)
            : SystemClock()
        self.container = AppContainer(
            clock: clock,
            launchConfiguration: launchConfiguration
        )
    }

    var body: some Scene {
        WindowGroup {
            RootTabView(
                dashboardViewModel: container.dashboardViewModel,
                archiveViewModel: container.archiveViewModel,
                settingsViewModel: container.settingsViewModel,
                makeAddItemViewModel: container.makeAddItemViewModel,
                makeEditItemViewModel: container.makeEditItemViewModel,
                screenshotScene: launchConfiguration.screenshotScene
            )
        }
    }

    private static var screenshotReferenceDate: Date {
        var components = DateComponents()
        components.calendar = Calendar(identifier: .gregorian)
        components.timeZone = TimeZone(secondsFromGMT: 0)
        components.year = 2026
        components.month = 3
        components.day = 6
        components.hour = 9
        components.minute = 41
        return components.date!
    }
}

private struct FrozenClock: Clock {
    let now: Date
}
