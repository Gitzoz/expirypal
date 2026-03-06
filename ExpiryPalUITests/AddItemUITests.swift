import XCTest

final class AddItemUITests: XCTestCase {
    func testAddItemCreatesDashboardRow() {
        let app = XCUIApplication()
        app.launchArguments += ["UITEST_MODE"]
        app.launch()

        let addButton = app.buttons["dashboard.addButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()

        let nameField = app.textFields["addItem.nameField"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 5))
        nameField.tap()
        nameField.typeText("Yogurt")

        let saveButton = app.buttons["addItem.saveButton"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 5))
        saveButton.tap()

        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Yogurt"].waitForExistence(timeout: 5))
    }
}
