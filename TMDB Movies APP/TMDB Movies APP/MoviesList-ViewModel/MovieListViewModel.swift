

import Foundation

enum MovieListState:Equatable {
    
    case idle
    case loading
    case success([Movie])
    case empty
    case failure(String)
}

protocol MovieListViewModelDelegate: AnyObject {
    func didUpdateState(_ state: MovieListState)
}

class MovieListViewModel {
    
    private let networkManager: NetworkManaging
    weak var delegate: MovieListViewModelDelegate?
    
    private(set) var state: MovieListState = .idle {
        didSet {
            delegate?.didUpdateState(state)
        }
    }
    
    init(networkManager: NetworkManaging = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchMovies() async {
        state = .loading
        do {
            let movies = try await networkManager.fetchMovies()
            state = movies.isEmpty ? .empty : .success(movies)
        } catch {
            state = .failure(error.localizedDescription)
        }
    }
    
    func search(query: String) async {
        state = .loading
        do {
            let movies = try await networkManager.searchMovies(query: query)
            state = movies.isEmpty ? .empty : .success(movies)
        } catch {
            state = .failure(error.localizedDescription)
        }
    }
    
    
}

