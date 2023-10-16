//
//  ViewController.swift
//  MovieList
//
//  Created by Igor Palyvoda on 11.10.2023.
//

import UIKit
import ESPullToRefresh

enum MovieSort: String, CaseIterable {
    case popular = "popular"
    case nowPlaying = "now_playing"
    case upcoming = "upcoming"
    
    var displaySortName: String {
        switch self {
        case .popular:
            return "Popular movies"
        case .nowPlaying:
            return "Now playing movies"
        case .upcoming:
            return "Upcoming movies"
        }
    }
}

class MainMovieViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var movieViewModel: MovieViewModelProtocol?
    private let searchController = UISearchController(searchResultsController: nil)
    private var currentPage: Int = 1
    private var movieSort: MovieSort = .popular
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    @IBAction private func sortButtonTapped(_ sender: Any) {
        guard let movieViewModel = movieViewModel, let tableView = tableView else { return }
        Utils.showMovieSortAlert(from: self) { [weak self] selectedSort in
            guard let self = self else { return }
            self.movieSort = selectedSort
            self.navigationItem.title = selectedSort.displaySortName
            self.fetchMovies(with: selectedSort)
        }
    }
    
    private func searchMovies(query: String) {
        guard let movieViewModel = movieViewModel, let tableView = tableView else { return }
        movieViewModel.searchMovie(movieTitle: query, completionHandler: {
            tableView.reloadData()
        })
    }
    
    private func configureUI() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
        self.navigationItem.title = MovieSort.popular.displaySortName
        
        self.fetchMovies()

        self.tableView.es.addPullToRefresh {
            [unowned self] in
            self.fetchMovies(with: self.movieSort)
            self.tableView.es.stopPullToRefresh()
        }
        
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
        pageControl.numberOfPages = movieViewModel?.totalPages ?? 1
    }
    
    @objc private func pageControlDidChange(_ sender: UIPageControl) {
        currentPage = sender.currentPage + 1
        fetchMovies(with: self.movieSort)
    }
    
    private func fetchMovies(with sort: MovieSort = .popular) {
        movieViewModel?.fetchMovies(page: currentPage, sortBy: sort, from: self) { [weak self] in
            guard let self = self else { return }
            pageControl.numberOfPages = movieViewModel?.totalPages ?? 1
            self.tableView.reloadData()
        }
    }
}

extension MainMovieViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            searchMovies(query: searchText)
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchMovies(with: movieSort)
    }
}
