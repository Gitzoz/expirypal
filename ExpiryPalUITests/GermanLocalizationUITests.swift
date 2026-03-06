import XCTest

final class GermanLocalizationUITests: XCTestCase {
    func testDashboardShowsGermanWithoutEnglishFallback() {
        let app = XCUIApplication()
        app.launchArguments += ["-AppleLanguages", "(de)", "-AppleLocale", "de_DE"]
        app.launch()

        XCTAssertTrue(app.staticTexts["Übersicht"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["Heute"].exists)
        XCTAssertFalse(app.staticTexts["Dashboard"].exists)
        XCTAssertFalse(app.staticTexts["Today"].exists)
    }
}
