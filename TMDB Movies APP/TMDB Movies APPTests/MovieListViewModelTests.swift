

import XCTest
@testable import TMDB_Movies_APP

final class MovieListViewModelTests: XCTestCase {
    
    // Mock Network Class
    class MockNetworkManager: NetworkManaging {
        var shouldReturnError = false
        var mockMovies: [Movie] = []
        
        func fetchMovies() async throws -> [Movie] {
            if shouldReturnError {
                throw NSError(domain: "TestError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Fetch failed"])
            }
            return mockMovies
        }
        
        func searchMovies(query: String) async throws -> [Movie] {
            if shouldReturnError {
                throw NSError(domain: "TestError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Search failed"])
            }
            return mockMovies.filter { $0.title.contains(query) }
        }
    }
    
    // Mock Delegate
    class MockMovieListViewModelDelegate: MovieListViewModelDelegate {
        var stateChanges: [MovieListState] = []
        weak var expectation: XCTestExpectation?
        private var hasFulfilled = false
        
        func didUpdateState(_ state: MovieListState) {
            stateChanges.append(state)
            if !hasFulfilled {
                expectation?.fulfill()
                hasFulfilled = true
            }
        }
    }
    
    // Test Cases
    
    func testFetchMoviesSuccess() async {
        
        let mockManager = MockNetworkManager()
        let expectedMovies = [
            Movie(id: 1, title: "Inception", overview: "Dreams", releaseDate: "2010-07-16", posterPath: nil)
        ]
        mockManager.mockMovies = expectedMovies
        
        let viewModel = MovieListViewModel(networkManager: mockManager)
        let delegate = MockMovieListViewModelDelegate()
        let expectation = expectation(description: "State should be .success with movies")
        delegate.expectation = expectation
        viewModel.delegate = delegate
        
        
        await viewModel.fetchMovies()
        
        
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(delegate.stateChanges.last, .success(expectedMovies))
    }
    
    func testFetchMoviesEmpty() async {
        
        let mockManager = MockNetworkManager()
        mockManager.mockMovies = []
        
        let viewModel = MovieListViewModel(networkManager: mockManager)
        let delegate = MockMovieListViewModelDelegate()
        let expectation = expectation(description: "State should be .empty")
        delegate.expectation = expectation
        viewModel.delegate = delegate
        
        
        await viewModel.fetchMovies()
        
        
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(delegate.stateChanges.last, .empty)
    }
    
    func testFetchMoviesFailure() async {
        
        let mockManager = MockNetworkManager()
        mockManager.shouldReturnError = true
        
        let viewModel = MovieListViewModel(networkManager: mockManager)
        let delegate = MockMovieListViewModelDelegate()
        let expectation = expectation(description: "State should be .failure with error message")
        delegate.expectation = expectation
        viewModel.delegate = delegate
        
        
        await viewModel.fetchMovies()
        
        
        await fulfillment(of: [expectation], timeout: 1.0)
        if case .failure(let errorMessage) = delegate.stateChanges.last {
            XCTAssertEqual(errorMessage, "Fetch failed")
        } else {
            XCTFail("Expected failure state")
        }
    }
    
    func testSearchMoviesSuccess() async {
        
        let mockManager = MockNetworkManager()
        let expectedMovies = [
            Movie(id: 2, title: "Interstellar", overview: "Space exploration", releaseDate: "2014-11-07", posterPath: nil)
        ]
        mockManager.mockMovies = expectedMovies
        
        let viewModel = MovieListViewModel(networkManager: mockManager)
        let delegate = MockMovieListViewModelDelegate()
        let expectation = expectation(description: "State should be .success with searched movies")
        delegate.expectation = expectation
        viewModel.delegate = delegate
        
        
        await viewModel.search(query: "Interstellar")
        
        
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(delegate.stateChanges.last, .success(expectedMovies))
    }
    
    func testSearchMoviesEmpty() async {
        
        let mockManager = MockNetworkManager()
        mockManager.mockMovies = []
        
        let viewModel = MovieListViewModel(networkManager: mockManager)
        let delegate = MockMovieListViewModelDelegate()
        let expectation = expectation(description: "State should be .empty for search")
        delegate.expectation = expectation
        viewModel.delegate = delegate
        
        
        await viewModel.search(query: "Nonexistent Movie")
        
        
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(delegate.stateChanges.last, .empty)
    }
    
    func testSearchMoviesFailure() async {
        
        let mockManager = MockNetworkManager()
        mockManager.shouldReturnError = true
        
        let viewModel = MovieListViewModel(networkManager: mockManager)
        let delegate = MockMovieListViewModelDelegate()
        let expectation = expectation(description: "State should be .failure for search")
        delegate.expectation = expectation
        viewModel.delegate = delegate
        
        
        await viewModel.search(query: "Error Movie")
        
        
        await fulfillment(of: [expectation], timeout: 1.0)
        if case .failure(let errorMessage) = delegate.stateChanges.last {
            XCTAssertEqual(errorMessage, "Search failed")
        } else {
            XCTFail("Expected failure state")
        }
    }
    
}
