//
//  ModelBuilder.swift
//  MovieList
//
//  Created by Igor Palyvoda on 16.10.2023.
//

import UIKit

protocol Builder {
    static func createMainModule() -> UIViewController
    static func createDetailModule() -> UIViewController
}

class ModelBuilder: Builder {
    static func createMainModule() -> UIViewController {
        if let mainMovieViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainMovieViewController") as? MainMovieViewController {
            let apiService = NetworkService()
            let movieViewModel = MovieViewModel(apiService: apiService)
            mainMovieViewController.movieViewModel = movieViewModel
            return mainMovieViewController
        }
        return UIViewController()
    }
    
    static func createDetailModule() -> UIViewController {
        if let detailMovieViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailMovieViewController") as? DetailMovieViewController {
            return detailMovieViewController
        }

        return UIViewController()
    }
}
