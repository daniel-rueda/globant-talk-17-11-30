//
//  TableViewRowActionsProvider.swift
//  GlobantTechTalk
//
//  Created by Daniel Rueda on 11/30/17.
//  Copyright © 2017 Daniel Rueda Jimenez. All rights reserved.
//

import Foundation
import UIKit

protocol TableViewRowActionsProvider: class {
    func deleteAction(forRowAt indexPath: IndexPath, from tableView: UITableView, performAction: @escaping (Int) -> Void) -> UITableViewRowAction
}

class TableViewRowActionsProviderConcrete: TableViewRowActionsProvider {
    func deleteAction(forRowAt indexPath: IndexPath, from tableView: UITableView, performAction: @escaping (Int) -> Void) -> UITableViewRowAction {
        let action = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            tableView.beginUpdates()
            performAction(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
        return action
    }
}
