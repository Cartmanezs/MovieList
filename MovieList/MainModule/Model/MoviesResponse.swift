//
//  MoviesResponse.swift
//  MovieList
//
//  Created by Igor Palyvoda on 15.10.2023.
//

import Foundation

struct MoviesResponse: Codable {
    let page: Int
    let totalPages: Int
    let totalResults: Int
    let results: [Movie]

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
