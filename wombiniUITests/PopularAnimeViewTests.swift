import XCTest
@testable import wombini

class PopularAnimeViewTests: XCTestCase {

    var viewModel: PopularAnimeViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = PopularAnimeViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    // Test if the view model fetches anime data
    func testFetchPopularAnime() {
        let expectation = self.expectation(description: "Fetching popular anime")
        
        viewModel.fetchPopularAnime { success in
            XCTAssertTrue(success)
            XCTAssertFalse(self.viewModel.animes.isEmpty)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    // Test if the fetched data is correctly displayed
    func testAnimeListPopulation() {
        viewModel.fetchPopularAnime { _ in
            XCTAssertEqual(self.viewModel.animes.count, 10) // Assume 10 items
        }
    }
    
    // Test for error handling
    func testFetchAnimeFailure() {
        viewModel.apiClient = MockAPIClient(shouldFail: true)
        
        viewModel.fetchPopularAnime { success in
            XCTAssertFalse(success)
            XCTAssertTrue(self.viewModel.animes.isEmpty)
        }
    }
}
