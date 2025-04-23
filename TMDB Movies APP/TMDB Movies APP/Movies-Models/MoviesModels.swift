

import Foundation

struct Movie: Decodable,Equatable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
    }
}

struct MovieResponse: Decodable {
    let results: [Movie]
}
