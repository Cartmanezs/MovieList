//
//  PlayerViewController.swift
//  MovieList
//
//  Created by Igor Palyvoda on 13.10.2023.
//

import UIKit
import youtube_ios_player_helper

class PlayerViewController: UIViewController, YTPlayerViewDelegate {

    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var closeButton: UIButton!
    
    var videoKey: String?
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .landscapeRight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    private func setupPlayer() {
        self.playerView.delegate = self
        if let videoKey = videoKey {
            playerView.load(withVideoId: videoKey, playerVars: ["playsinline": "1"])
        }
    }
}

