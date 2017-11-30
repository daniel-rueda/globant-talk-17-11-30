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
    var manager: NetworkManager = NetworkManagerConcrete()

    func loadQuote(onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void) {
        let url = URL(string: "https://api.github.com/zen")!
        manager.request(url: url, onSuccess: { (data) in
            let value = String(data: data, encoding: .utf8)!
            DispatchQueue.main.async {
                onSuccess(value)
            }
        }, onFailure: { (error) in
            DispatchQueue.main.async {
                onFailure("Error: \(error.localizedDescription)")
            }
        })
    }
}
