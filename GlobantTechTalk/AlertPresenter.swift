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
    func show(message: String)
}

class AlertPresenterConcrete: AlertPresenter {
    var controller: UIViewController { return UIApplication.shared.keyWindow!.rootViewController! }

    func show(message: String) {
        let alertController = UIAlertController(title: "Application", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        controller.present(alertController, animated: true, completion: nil)
    }
}
