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

    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        let url = URL(string: "https://api.github.com/zen")!
        let task = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            if let data = data {
                let value = String(data: data, encoding: .utf8)!
                self.values.append(value)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            if let response = urlResponse as? HTTPURLResponse {
                if response.statusCode == 403 {
                    let status = response.allHeaderFields["Status"] as? String
                    let alertController = UIAlertController(title: "API", message: "Error: \(status!)", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default) { _ in
                        self.values.removeLast()
                        self.tableView.reloadData()
                    }
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            if let error = error {
                let alertController = UIAlertController(title: "Application", message: "Error: \(error.localizedDescription)", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        task.resume()
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
