//
//  MovieViewModel.swift
//  MovieList
//
//  Created by Igor Palyvoda on 11.10.2023.
//

import UIKit

protocol MovieViewModelProtocol {
    func numberOfRows() -> Int
    var movies: [Movie] { get set }
    var totalPages: Int { get }
    func fetchMovies(page: Int, sortBy sort: MovieSort, from viewController: UIViewController, completionHandler: @escaping () -> Void)
    func searchMovie(movieTitle: String, completionHandler: @escaping () -> Void)
}

class MovieViewModel: MovieViewModelProtocol {
    
    private let networkService: NetworkDataProtocol
    private var currentPage: Int = 1
    var movies: [Movie] = []
    var totalPages: Int = 1
    
    init(apiService: NetworkDataProtocol) {
        self.networkService = apiService
    }
        
    func fetchMovies(page: Int, sortBy sort: MovieSort, from viewController: UIViewController, completionHandler: @escaping () -> Void) {
        networkService.loadMovies(page, sortBy: sort, from: viewController) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result{
                case .success(let movieResult):
                    self.movies = movieResult.results
                    self.totalPages = movieResult.totalPages
                case .failure(let error):
                    print("error \(error.localizedDescription)")
                }
                completionHandler()
            }
        }
    }
    
    func searchMovie(movieTitle: String, completionHandler: @escaping () -> Void) {
        networkService.searchMovies(query: movieTitle) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self.movies = movies
                case .failure(let error):
                    print("Search error: \(error.localizedDescription)")
                }
                completionHandler()
            }
        }
    }
    
    func numberOfRows() -> Int {
        return movies.count
    }
}
