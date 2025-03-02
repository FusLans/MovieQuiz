import XCTest
@testable import MovieQuiz

class MoviesLoaderTests: XCTestCase {
    func testSuccsesLoading() throws {
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            switch result {
            case .success(_):
                expectation.fulfill()
                
                
            case .failure(_):
                XCTFail("Unexpected failure")
            }
        }
        waitForExpectations(timeout: 1)
        
    }
    
    func testFailureLoading() throws {
        let stubNetworkClient = StubNetworkClient(emulateError: true)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            case .success(_):
                XCTFail("Unexpected failure")
            }
        }
        waitForExpectations(timeout: 1)
        
    }
}
