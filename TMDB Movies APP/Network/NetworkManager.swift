

import Foundation


protocol NetworkManaging {
    func fetchMovies() async throws -> [Movie]
    func searchMovies(query: String) async throws -> [Movie]
}

extension NetworkManager: NetworkManaging {}

enum API {
    static let imageBaseURL = "https://image.tmdb.org/t/p/w500"
}

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case decodingError
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .invalidResponse:
            return "Invalid server response."
        case .statusCode(let code):
            return "Server returned status code: \(code)"
        case .decodingError:
            return "Failed to decode data."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey = "f787c90b120f94542ea094df9f6f786f"

    private init() {}

    func fetchMovies() async throws -> [Movie] {
        let urlString = "\(baseURL)/discover/movie?api_key=\(apiKey)"
        return try await fetchData(from: urlString)
    }

    func searchMovies(query: String) async throws -> [Movie] {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw NetworkError.invalidURL
        }
        let urlString = "\(baseURL)/search/movie?query=\(encodedQuery)&api_key=\(apiKey)"
        return try await fetchData(from: urlString)
    }

    private func fetchData(from urlString: String) async throws -> [Movie] {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.statusCode(httpResponse.statusCode)
            }

            do {
                let decoded = try JSONDecoder().decode(MovieResponse.self, from: data)
                return decoded.results
            } catch {
                throw NetworkError.decodingError
            }
        } catch {
            throw NetworkError.unknown(error)
        }
    }
}


