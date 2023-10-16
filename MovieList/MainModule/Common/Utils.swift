//
//  Utils.swift
//  MovieList
//
//  Created by Igor Palyvoda on 12.10.2023.
//

import UIKit

class Utils {
    static func showAlert(title: String? = nil, message: String, from viewController: UIViewController, handler: ((UIAlertAction) -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: handler)
        alert.addAction(cancel)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func showMovieSortAlert(from viewController: UIViewController, completion: @escaping (MovieSort) -> Void) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for movieSort in MovieSort.allCases {
            let action = UIAlertAction(title: movieSort.displaySortName, style: .default) { (action) in
                completion(movieSort)
            }
            alertController.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}

