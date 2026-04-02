import XCTest

final class GermanLocalizationUITests: XCTestCase {
    func testDashboardShowsGermanWithoutEnglishFallback() {
        let app = XCUIApplication()
        app.launchArguments += ["UITEST_MODE", "-AppleLanguages", "(de)", "-AppleLocale", "de_DE"]
        app.launch()

        XCTAssertTrue(app.staticTexts["Übersicht"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["Keine aktiven Einträge"].exists)
        XCTAssertFalse(app.staticTexts["Dashboard"].exists)
        XCTAssertFalse(app.staticTexts["No active items"].exists)
    }

    func testEnglishDashboardScreenshotSceneShowsLocalizedLocationLabels() {
        let app = launchScreenshotScene(.dashboard, language: "en", locale: "en_US")

        XCTAssertTrue(app.staticTexts["Dashboard"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Fridge"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Pantry"].exists)
        XCTAssertFalse(app.staticTexts["location.fridge"].exists)
        XCTAssertFalse(app.staticTexts["location.pantry"].exists)
    }

    func testEnglishArchiveScreenshotSceneShowsLocalizedArchiveLabels() {
        let app = launchScreenshotScene(.archive, language: "en", locale: "en_US")

        XCTAssertTrue(app.staticTexts["Archive"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Consumed"].exists)
        XCTAssertTrue(app.staticTexts["Discarded"].exists)
        XCTAssertTrue(app.staticTexts["Pantry"].exists)
        XCTAssertTrue(app.staticTexts["Fridge"].exists)
        XCTAssertFalse(app.staticTexts["location.pantry"].exists)
        XCTAssertFalse(app.staticTexts["location.fridge"].exists)
    }

    func testEnglishSettingsScreenshotSceneShowsInterpolatedValues() {
        let app = launchScreenshotScene(.settings, language: "en", locale: "en_US")

        XCTAssertTrue(app.staticTexts["Settings"].waitForExistence(timeout: 5))
        XCTAssertTrue(
            app.steppers["settings.notifyDaysBeforeStepper"].label.contains("Notify 4 days before expiry")
        )
        XCTAssertTrue(app.datePickers["settings.notificationTimePicker"].exists)
    }

    func testEnglishAddItemScreenshotSceneShowsClearTitle() {
        let app = launchScreenshotScene(.addItem, language: "en", locale: "en_US")

        XCTAssertTrue(app.staticTexts["Add Item"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["screenshot.mode.title"].exists)
        XCTAssertTrue(app.textFields["addItem.nameField"].exists)
    }

    func testEnglishEditItemScreenshotSceneShowsClearTitle() {
        let app = launchScreenshotScene(.editItem, language: "en", locale: "en_US")

        let editNameField = app.textFields["editItem.nameField"]
        let screenshotTitle = app
            .staticTexts
            .matching(identifier: "screenshot.mode.title")
            .matching(NSPredicate(format: "label == %@", "Edit Item"))
            .firstMatch

        XCTAssertTrue(editNameField.waitForExistence(timeout: 8))
        XCTAssertTrue(screenshotTitle.waitForExistence(timeout: 8))
        XCTAssertEqual(screenshotTitle.label, "Edit Item")
    }

    func testGermanDashboardScreenshotSceneShowsGermanLabelsWithoutFallback() {
        let app = launchScreenshotScene(.dashboard, language: "de", locale: "de_DE")

        XCTAssertTrue(app.staticTexts["Übersicht"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Kühlschrank"].exists)
        XCTAssertTrue(app.staticTexts["Vorratsschrank"].exists)
        XCTAssertFalse(app.staticTexts["Dashboard"].exists)
        XCTAssertFalse(app.staticTexts["Fridge"].exists)
        XCTAssertFalse(app.staticTexts["location.fridge"].exists)
    }

    @discardableResult
    private func launchScreenshotScene(_ scene: ScreenshotSceneName, language: String, locale: String) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments += [
            "SCREENSHOT_MODE",
            "SCREENSHOT_SCENE=\(scene.rawValue)",
            "-AppleLanguages", "(\(language))",
            "-AppleLocale", locale
        ]
        app.launch()
        return app
    }
}

private enum ScreenshotSceneName: String {
    case dashboard
    case addItem
    case editItem
    case archive
    case settings
}
