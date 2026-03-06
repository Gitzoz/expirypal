import XCTest

final class EditItemUITests: XCTestCase {
    func testEditItemUpdatesDashboardRow() {
        let app = XCUIApplication()
        app.launchArguments += ["UITEST_MODE", "-AppleLanguages", "(en)", "-AppleLocale", "en_US"]
        app.launch()

        app.buttons["dashboard.addButton"].tap()
        let nameField = app.textFields["addItem.nameField"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 5))
        nameField.tap()
        nameField.typeText("Milk")
        app.buttons["addItem.saveButton"].tap()

        XCTAssertTrue(app.staticTexts["Milk"].waitForExistence(timeout: 5))
        app.staticTexts["Milk"].tap()

        let editNameField = app.textFields["editItem.nameField"]
        XCTAssertTrue(editNameField.waitForExistence(timeout: 5))
        editNameField.tap()
        editNameField.typeText(" Updated")
        app.buttons["editItem.saveButton"].tap()

        XCTAssertTrue(app.staticTexts["Milk Updated"].waitForExistence(timeout: 5))
    }
}
