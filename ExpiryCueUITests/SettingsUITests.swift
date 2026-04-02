import XCTest

final class SettingsUITests: XCTestCase {
    func testSettingsPersistWithinSession() {
        let app = XCUIApplication()
        app.launchArguments += ["UITEST_MODE", "-AppleLanguages", "(en)", "-AppleLocale", "en_US"]
        app.launch()

        app.tabBars.buttons["Settings"].tap()
        let notifyDaysStepper = app.steppers["settings.notifyDaysBeforeStepper"]
        XCTAssertTrue(notifyDaysStepper.waitForExistence(timeout: 5))
        app.buttons["settings.notifyDaysBeforeStepper-Increment"].tap()
        app.buttons["settings.saveButton"].tap()

        app.tabBars.buttons["Dashboard"].tap()
        app.tabBars.buttons["Settings"].tap()
        XCTAssertTrue(app.staticTexts["Notify 4 days before expiry"].waitForExistence(timeout: 5))
    }
}
