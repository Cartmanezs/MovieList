//
//  MovieTableViewCell.swift
//  MovieList
//
//  Created by Igor Palyvoda on 11.10.2023.
//

import UIKit
import SDWebImage
import Cosmos

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var movieRatinginStars: CosmosView!
    @IBOutlet weak var movieImage: UIImageView! {
        didSet {
            movieImage.layer.shadowColor = UIColor.red.cgColor
            movieImage.layer.shadowOpacity = 0.5
            movieImage.layer.shadowOffset = CGSize(width: 3, height: 3)
            movieImage.layer.shadowRadius = 6
            movieImage.layer.masksToBounds = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with viewModel: MovieCellViewModelProtocol) {
        movieTitle.text = viewModel.title
        movieGenre.text = viewModel.genre
        movieRating.text = viewModel.rating
        movieRatinginStars.rating = viewModel.voteAverage / 2
        setupImage(viewModel.posterPath)
    }
    
    private func setupImage(_ path: String?) {
        if let path = path, let url = URL(image: path) {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            self.movieImage.sd_setImage(with: url, placeholderImage: nil, options: [.refreshCached, .continueInBackground]) { [weak self] (image, error, cacheType, imageURL) in
                guard let self = self else { return }
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }
    }
}
