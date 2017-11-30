//
//  URLSessionProtocol.swift
//  GlobantTechTalk
//
//  Created by Daniel Rueda on 11/30/17.
//  Copyright © 2017 Daniel Rueda Jimenez. All rights reserved.
//

import Foundation

protocol URLSessionProtocol: class {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {
    // URLSession already implements the method in the protocol :)
}
