//
//  HistoryTableViewController.swift
//  DNAConverter
//
//  Created by makoto on 2020/01/10.
//  Copyright © 2020 makoto. All rights reserved.
//

import UIKit

protocol HistoryTableViewControllerDelegate: AnyObject {
    func historyTableViewController(_ historyTableViewController: HistoryTableViewController, didSelectHistory history: String)
}

final class HistoryTableViewController: UIViewController {

    weak var delegate: HistoryTableViewControllerDelegate?
    @IBOutlet private weak var noHistoryLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    let historyModel = HistoryModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        let isHiddenTable = historyModel.histories.isEmpty
        noHistoryLabel.isHidden = !isHiddenTable
        tableView.isHidden = isHiddenTable
    }
}

extension HistoryTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.historyTableViewController(self, didSelectHistory: historyModel.histories[indexPath.row])
    }
}

extension HistoryTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyModel.histories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = historyModel.histories[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}
