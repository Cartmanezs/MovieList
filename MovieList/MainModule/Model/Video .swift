//
//  Video .swift
//  MovieList
//
//  Created by Igor Palyvoda on 16.10.2023.
//

import Foundation

struct VideoResults: Codable {
    let results: [VideoKey]
}

struct VideoKey: Codable {
    let key: String
    let id: String
}
