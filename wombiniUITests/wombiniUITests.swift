import XCTest

class AnimePopularViewUITests: XCTestCase {
    
    override func setUpWithError() throws {
            continueAfterFailure = false

            // Launch the application
            let app = XCUIApplication()
            app.launch()

            // Ensure the device is in portrait orientation
            let device = XCUIDevice.shared
            if device.orientation != .portrait {
                device.orientation = .portrait
            }
        }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testWaitForManualTapOnAnime() throws {
        let app = XCUIApplication()
        app.launch()

        // Step 1: Tap on the "Trending" button to navigate to PopularAnimeView
        let trendingButton = app.buttons["trendingButton"]
        XCTAssertTrue(trendingButton.exists, "Trending button should be present")
        trendingButton.tap()

        // Step 2: Perform a search within the PopularAnimeView
        let searchField = app.textFields["SearchAnimeField"]
        XCTAssertTrue(searchField.exists, "The search field should be present")

        // Input search text (e.g., "Dandadan")
        searchField.tap()
        searchField.typeText("Dandadan")

        // Step 3: Scroll and tap on the anime in the list (Dandadan)
        XCUIApplication().scrollViews.containing(.other, identifier: "Vertical scroll bar, 2 pages")
            .children(matching: .other).element(boundBy: 0)
            .children(matching: .other).element.tap()

        // Step 4: Verify if the detail view is showing the correct anime title after tapping
        let detailTitle = app.staticTexts["Dandadan"]  // Replace "Dandadan" with actual title shown in the detail view
        XCTAssertTrue(detailTitle.exists, "The detail view for the anime 'Dandadan' should be displayed")
    }
}
