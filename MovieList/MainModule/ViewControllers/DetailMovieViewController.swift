//
//  DetailMovieViewController.swift
//  MovieList
//
//  Created by Igor Palyvoda on 12.10.2023.
//

import UIKit
import SDWebImage
import AVFoundation

class DetailMovieViewController: UIViewController {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieCountry: UILabel!
    @IBOutlet weak var movieGenres: UILabel!
    @IBOutlet weak var trailerButton: UIButton!
    
    var selectedMovie: Movie?
    var detailViewModel: DetailMovieViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    @IBAction func trailerButtonTapped(_ sender: UIButton) {
        configureTrailerButtonTapped()
    }
}

private extension DetailMovieViewController {
    func configureTrailerButtonTapped() {
        guard let key = detailViewModel?.videos.first?.key else {
            return
        }
        let sb = UIStoryboard(name: "Player", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "PlayerViewController") as! PlayerViewController
        vc.videoKey = key
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: false, completion: nil)
    }
    
    func configureUI() {
        movieName.text = detailViewModel?.movieName
        movieCountry.text = detailViewModel?.movieOverview
        movieImageView.sd_setImage(with: detailViewModel?.moviePosterURL)
        movieImageView.sd_setImage(with:  detailViewModel?.moviePosterURL)
        
        displayMovieGenresWithVideo()
    }
    
    func displayMovieGenresWithVideo() {
        detailViewModel?.fetchMovieDetail(from: self) { [weak self] in
            guard let self = self else { return }
            let genresText = self.detailViewModel?.getGenresText() ?? ""
            self.movieGenres.text = genresText
        }
        
        detailViewModel?.fetchVideo { [weak self] in
            guard let self = self else { return }
            self.trailerButton.isHidden = false
        }
     }
}
