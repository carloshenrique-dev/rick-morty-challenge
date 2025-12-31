import XCTest

final class rick_morty_challengeUITests: XCTestCase {
    @MainActor
    func testAppFlow() throws {
        let app = XCUIApplication()
        app.launch()
        
        let charactersTitle = app.navigationBars["Characters"]
        XCTAssertTrue(charactersTitle.exists, "Characters title should be visible")
        
        takeScreenshot(named: "1-CharacterList", app: app)
        
        let rickText = app.staticTexts["Rick Sanchez"]
        let exists = rickText.waitForExistence(timeout: 10)
        XCTAssertTrue(exists, "Rick Sanchez text should appear in the list")
        
        rickText.firstMatch.tap()
        
        let detailName = app.staticTexts["Rick Sanchez"]
        XCTAssertTrue(detailName.waitForExistence(timeout: 2), "Character name should be visible in detail view")
        
        let speciesText = app.staticTexts["Human"]
        XCTAssertTrue(speciesText.exists, "Species should be visible")
        
        takeScreenshot(named: "2-CharacterDetail", app: app)
        
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        let searchField = app.searchFields["Search by name"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 2), "Search field should exist")
        
        searchField.tap()
        searchField.typeText("Morty")
        
        let mortyText = app.staticTexts["Morty Smith"]
        XCTAssertTrue(mortyText.waitForExistence(timeout: 5), "Morty Smith text should appear after search")
        
        takeScreenshot(named: "3-SearchResult", app: app)
    }
    
    private func takeScreenshot(named name: String, app: XCUIApplication) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
