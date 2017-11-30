//
//  ViewController.swift
//  GlobantTechTalk
//
//  Created by Daniel Rueda on 11/29/17.
//  Copyright © 2017 Daniel Rueda Jimenez. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var values: [String] = []
    var service: GitHubService = GitHubServiceConcrete()
    var presenter: AlertPresenter = AlertPresenterConcrete()

    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        service.loadQuote(onSuccess: { (value) in
            self.values.append(value)
            self.tableView.reloadData()
        }, onFailure: { (error) in
            self.presenter.show(message: error)
        })
    }

    // MARK: - TableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mx.drj.demo.ui.cell", for: indexPath)
        let value = values[indexPath.row]
        cell.textLabel?.text = value
        return cell
    }

    // MARK: - TableViewDelegate
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.tableView.beginUpdates()
            self.values.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
        }
        return [action]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
