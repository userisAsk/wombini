import XCTest

class PopularAnimeViewUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
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
        
        // Add a custom pause to allow manual interaction
        print("Manually tap on the anime in the UI now.")
        sleep(10)  // Pauses the test for 10 seconds, allowing time for manual tap
        
        // Check if the detail view is showing the correct anime title after manual tap
        let detailTitle = app.staticTexts["Dandadan"]  // Replace "Dandadan" with the actual title in your detail view
        let exists = NSPredicate(format: "exists == 1")
        
        expectation(for: exists, evaluatedWith: detailTitle, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertTrue(detailTitle.exists, "The detail view for the anime 'Dandadan' should be displayed")
    }



}
