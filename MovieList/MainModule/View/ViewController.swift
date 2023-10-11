//
//  ViewController.swift
//  MovieList
//
//  Created by Igor Palyvoda on 11.10.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = searchBar
        
    }


}

