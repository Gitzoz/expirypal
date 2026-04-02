import XCTest

final class ArchiveUITests: XCTestCase {
    func testMarkConsumedMovesItemToArchive() {
        let app = XCUIApplication()
        app.launchArguments += ["UITEST_MODE", "-AppleLanguages", "(en)", "-AppleLocale", "en_US"]
        app.launch()

        app.buttons["dashboard.addButton"].tap()
        let nameField = app.textFields["addItem.nameField"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 5))
        nameField.tap()
        nameField.typeText("Soup")
        app.buttons["addItem.saveButton"].tap()

        XCTAssertTrue(app.staticTexts["Soup"].waitForExistence(timeout: 5))
        app.staticTexts["Soup"].tap()
        let markConsumedButton = app.buttons["editItem.markConsumedButton"]
        XCTAssertTrue(markConsumedButton.waitForExistence(timeout: 5))
        markConsumedButton.tap()

        XCTAssertFalse(app.staticTexts["Soup"].waitForExistence(timeout: 2))
        app.tabBars.buttons["Archive"].tap()
        XCTAssertTrue(app.staticTexts["Soup"].waitForExistence(timeout: 5))
    }
}
