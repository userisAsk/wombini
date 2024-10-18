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
                
        
        // Perform a search
        let searchField = app.textFields["SearchAnimeField"]
        XCTAssertTrue(searchField.exists, "The search field should be present")

        // Input search text (e.g., "Dandadan")
        searchField.tap()
        searchField.typeText("Dandadan")
        XCUIApplication().scrollViews.containing(.other, identifier:"Vertical scroll bar, 2 pages").children(matching: .other).element(boundBy: 0).children(matching: .other).element.tap()

        // Check if the detail view is showing the correct anime title after manual tap
                let detailTitle = app.staticTexts["Dandadan"]  // Replace "Dandadan" with the actual title in your detail view
        

        XCTAssertTrue(detailTitle.exists, "The detail view for the anime 'Dandadan' should be displayed")
    }



}
