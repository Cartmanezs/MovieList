//
//  MovieGenre.swift
//  MovieList
//
//  Created by Igor Palyvoda on 16.10.2023.
//

import Foundation

struct MovieGenre: Codable {
    let id: Int
    let name: String
}

struct MovieDetailResults: Codable {
    let genres : [MovieGenre]
}
