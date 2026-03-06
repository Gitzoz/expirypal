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
}
