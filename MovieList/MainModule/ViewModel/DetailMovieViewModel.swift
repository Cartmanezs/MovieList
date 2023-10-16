//
//  DetailMovieViewModel.swift
//  MovieList
//
//  Created by Igor Palyvoda on 16.10.2023.
//

import UIKit

protocol DetailMovieViewModelProtocol {
    var movieName: String { get }
    var movieOverview: String { get }
    var moviePosterURL: URL? { get }
    var genres: [MovieGenre] { get }
    var videos: [VideoKey] { get }
    func fetchMovieDetail(from viewController: UIViewController, _ completionHandler: @escaping () -> Void)
    func fetchVideo(_ completionHandler: @escaping () -> Void)
}

extension DetailMovieViewModelProtocol {
    func getGenresText() -> String {
        return genres.map { $0.name }.joined(separator: ", ")
    }
}


class DetailMovieViewModel: DetailMovieViewModelProtocol {
    var genres: [MovieGenre] = []
    var videos: [VideoKey] = []

    private let apiService: NetworkDataProtocol
    private var selectedMovie: Movie?
    
    var movieName: String {
        return selectedMovie?.title ?? ""
    }
    
    var movieOverview: String {
        return selectedMovie?.overview ?? ""
    }
    
    var moviePosterURL: URL? {
        return URL(image: selectedMovie?.posterPath ?? "")
    }

    init(selectedMovie: Movie?,apiService: NetworkDataProtocol) {
        self.selectedMovie = selectedMovie
        self.apiService = apiService
    }

    func fetchMovieDetail(from viewController: UIViewController, _ completionHandler: @escaping () -> Void) {
        apiService.loadMovieDetail(selectedMovie?.id ?? 0, from: viewController) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let genres):
                    self.genres = genres
                case .failure(let error):
                    print("error \(error.localizedDescription)")
                }
                completionHandler()
            }
        }
    }

    func fetchVideo( _ completionHandler: @escaping () -> Void) {
        apiService.loadVideo(selectedMovie?.id ?? 0) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let videos):
                    self.videos = videos
                case .failure(let error):
                    print("error \(error.localizedDescription)")
                }
                completionHandler()
            }
        }
    }
}

