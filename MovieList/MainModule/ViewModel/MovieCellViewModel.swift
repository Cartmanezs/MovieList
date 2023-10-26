//
//  MovieCellViewModel.swift
//  MovieList
//
//  Created by Igor Palyvoda on 26.10.2023.
//

import Foundation

protocol MovieCellViewModelProtocol: AnyObject {
    var title: String { get }
    var genre: String { get }
    var rating: String { get }
    var voteAverage: Double { get }
    var posterPath: String? { get }
}

class MovieCellViewModel: MovieCellViewModelProtocol {
    private var movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    var title: String {
        return movie.title
    }
    
    var genre: String {
        return movie.genres?.first?.name ?? ""
    }
    
    var rating: String {
        return "\(movie.voteAverage)"
    }
    
    var voteAverage: Double {
        return movie.voteAverage
    }
    
    var posterPath: String? {
        return movie.posterPath
    }
}
