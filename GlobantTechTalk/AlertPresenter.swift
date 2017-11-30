//
//  AlertPresenter.swift
//  GlobantTechTalk
//
//  Created by Daniel Rueda on 11/30/17.
//  Copyright © 2017 Daniel Rueda Jimenez. All rights reserved.
//

import Foundation
import UIKit

protocol AlertPresenter: class {
    func show(message: String, from controller: UIViewController)
}

class AlertPresenterConcrete: AlertPresenter {
    func show(message: String, from controller: UIViewController) {
        let alertController = UIAlertController(title: "Application", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        controller.present(alertController, animated: true, completion: nil)
    }
}
