//
//  NetworkManager.swift
//  GlobantTechTalk
//
//  Created by Daniel Rueda on 11/30/17.
//  Copyright © 2017 Daniel Rueda Jimenez. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case forbidden
}

protocol NetworkManager: class {
    func request(url: URL, onSuccess: @escaping (Data) -> Void, onFailure: @escaping (Error) -> Void)
}

class NetworkManagerConcrete: NetworkManager {
    var session: URLSessionProtocol = URLSession.shared

    func request(url: URL, onSuccess: @escaping (Data) -> Void, onFailure: @escaping (Error) -> Void) {
        let task = session.dataTask(with: url) { (data, urlResponse, error) in
            if let data = data {
                onSuccess(data)
            }
            if let response = urlResponse as? HTTPURLResponse, response.statusCode == 403 {
                onFailure(NetworkError.forbidden)
            } else if let error = error {
                onFailure(error)
            }
        }
        task.resume()
    }
}
