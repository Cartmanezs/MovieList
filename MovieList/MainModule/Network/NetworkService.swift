//
//  NetworkService.swift
//  MovieList
//
//  Created by Igor Palyvoda on 11.10.2023.
//

import Foundation
import Alamofire

enum MovieLoadError: Error {
    case invalidStatusCode(Int)
    case invalidURL
    case noData
    case emptySearch
    case networkError(Error)
    case decodingError
    
    var displayError: String {
        switch self {
        case .invalidStatusCode(let status):
            return "Invalid status code \(status)"
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .emptySearch:
            return "No search result"
        case .networkError(let error):
            return "Network Error \(error)"
        case .decodingError:
            return "Decoding Error"
        }
    }
}

protocol NetworkDataProtocol {
    func searchMovies(query: String, completion: @escaping (Result<[Movie], MovieLoadError>) -> Void)
    func loadMovies(_ page: Int, sortBy sort: MovieSort, from viewController: UIViewController, completion: @escaping (Result<MoviesResponse, MovieLoadError>) -> Void)
    func loadMovieDetail(_ movieId: Int, from viewController: UIViewController, completion: @escaping (Result<[MovieGenre], MovieLoadError>) -> Void)
    func loadVideo(_ movieId: Int, completion: @escaping (Result<[VideoKey], Error>) -> Void)
}

class NetworkService: NetworkDataProtocol {
    
    private let apiKey = "a929eb5e394dc20a1f4e0731a2623597"
    private let baseURL = "https://api.themoviedb.org/3/"

    func searchMovies(query: String, completion: @escaping (Result<[Movie], MovieLoadError>) -> Void) {
        let urlString = "\(baseURL)search/movie"
        guard var urlComponents = URLComponents(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "query", value: query)
        ]

        guard let url = urlComponents.url else {
            completion(.failure(.invalidURL))
            return
        }

        AF.request(url, method: .get).responseDecodable(of: MoviesResponse.self) { response in
            switch response.result {
            case .success(let movieResponse):
                let movies = movieResponse.results
                if !movies.isEmpty {
                    completion(.success(movies))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(.networkError(error)))
            }
        }
    }

    func loadMovies(_ page: Int, sortBy sort: MovieSort, from viewController: UIViewController, completion: @escaping (Result<MoviesResponse, MovieLoadError>) -> Void) {
        let urlString: String = "\(baseURL)movie/\(sort)?"
        
        let parameters: [String: Any] = ["api_key": apiKey, "language": "en-US", "page": page]
        
        AF.request(urlString, method: .get, parameters: parameters).responseData { response in
            switch response.result {
            case .success(let data):
                let successRange = 200..<300
                if let statusCode = response.response?.statusCode, successRange.contains(statusCode) {
                    if let result = self.decodeMovie(data) {
                        completion(.success(result))
                    }
                } else {
                    Utils.showAlert(message: MovieLoadError.decodingError.displayError, from: viewController)
                    completion(.failure(.decodingError))
                }
            case .failure(let error):
                Utils.showAlert(message: MovieLoadError.networkError(error).displayError, from: viewController)
                completion(.failure(.networkError(error)))
            }
        }
    }
    
    func loadMovieDetail(_ movieId: Int, from viewController: UIViewController, completion: @escaping (Result<[MovieGenre], MovieLoadError>) -> Void) {
        guard Connectivity.isConnectedToInternet else {
            Utils.showAlert(message: "No Internet connection", from: viewController)
            return
        }
        
        let url = "\(baseURL)movie/\(movieId)?"
        let parameters: [String: Any] = [
            "api_key": apiKey,
            "language": "en-US"
        ]
        
        AF.request(url, method: .get, parameters: parameters).responseData { response in
            switch response.result {
            case .success(let data):
                if let statusCode = response.response?.statusCode, 200..<300 ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(MovieDetailResults.self, from: data)
                        let genres = response.genres
                        completion(.success(genres))
                    } catch {
                        Utils.showAlert(message: MovieLoadError.decodingError.displayError, from: viewController)
                        completion(.failure(.decodingError))
                    }
                } else {
                    Utils.showAlert(message: MovieLoadError.decodingError.displayError, from: viewController)
                    completion(.failure(.decodingError))
                }
            case .failure(let error):
                Utils.showAlert(message: MovieLoadError.networkError(error).displayError, from: viewController)
                completion(.failure(.networkError(error)))
            }
        }
    }
    
    func loadVideo(_ movieId: Int, completion: @escaping (Result<[VideoKey], Error>) -> Void) {
        let urlString = "\(baseURL)movie/\(movieId)/videos"
        let parameters: [String: Any] = ["api_key": apiKey, "language": "en-US"]
        
        AF.request(urlString, method: .get, parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: VideoResults.self) { response in
                switch response.result {
                case .success(let videoResults):
                    let videoKeys = videoResults.results
                    completion(.success(videoKeys))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

}

private extension NetworkService {
    func decodeVideo (_ data: Data) -> [VideoKey] {
        do{
            let decoder = JSONDecoder()
            let response = try decoder.decode(VideoResults.self, from: data)
            let videoKey = response.results
            return videoKey
        } catch _ {
            return []
        }
    }
    
    func decodeMovie(_ data: Data) -> MoviesResponse? {
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(MoviesResponse.self, from: data)
            let movie = response
            return movie
        } catch {
            return nil
        }
    }
    
    func decodeMovieDetail(_ data: Data) -> [MovieGenre] {
        do{
            let decoder = JSONDecoder()
            let response = try decoder.decode(MovieDetailResults.self, from: data)
            let genres = response.genres
            return genres
        } catch _ {
            return []
        }
    }
}
