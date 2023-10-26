//
//  MainMovieViewControllerTableViewExtension.swift
//  MovieList
//
//  Created by Igor Palyvoda on 12.10.2023.
//

import UIKit

extension MainMovieViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieViewModel?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as? MovieTableViewCell,
              let viewModel = movieViewModel else { return UITableViewCell() }
        
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        cell.viewModel = cellViewModel
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 315.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = movieViewModel?.movies[indexPath.row]
        if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailMovieViewController") as? DetailMovieViewController {
            detailViewController.detailViewModel = DetailMovieViewModel(selectedMovie: selectedMovie, apiService: NetworkService())
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
