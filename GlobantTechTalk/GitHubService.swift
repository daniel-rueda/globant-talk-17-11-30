//
//  GitHubService.swift
//  GlobantTechTalk
//
//  Created by Daniel Rueda on 11/30/17.
//  Copyright © 2017 Daniel Rueda Jimenez. All rights reserved.
//

import Foundation

protocol GitHubService: class {
    func loadQuote(onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void)
}

class GitHubServiceConcrete: GitHubService {
    func loadQuote(onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void) {
        let url = URL(string: "https://api.github.com/zen")!
        let task = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            if let data = data {
                let value = String(data: data, encoding: .utf8)!
                DispatchQueue.main.async {
                    onSuccess(value)
                }
            }
            if let response = urlResponse as? HTTPURLResponse {
                if response.statusCode == 403 {
                    let status = response.allHeaderFields["Status"] as? String
                    DispatchQueue.main.async {
                        onFailure("Error: \(status!)")
                    }
                }
            }
            if let error = error {
                DispatchQueue.main.async {
                    onFailure("Error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
}
