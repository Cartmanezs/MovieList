//
//  UrlExtension.swift
//  MovieList
//
//  Created by Igor Palyvoda on 12.10.2023.
//

import Foundation

extension URL {
    init?(image path: String) {
        let baseUrl = "https://image.tmdb.org/t/p/w300/"
        self.init(string: "\(baseUrl)\(path)")
    }
}
