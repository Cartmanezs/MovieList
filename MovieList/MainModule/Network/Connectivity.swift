//
//  Connectivity.swift
//  MovieList
//
//  Created by Igor Palyvoda on 12.10.2023.
//

import Alamofire

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
