//
//  FollowerListViewController.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/11/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

protocol FollowerListViewControllerDelegate: class {
    func followerListViewController(_ controller: FollowerListViewController, didSelect follower: User)
}

class FollowerListViewController: UITableViewController {

    weak var delegate: FollowerListViewControllerDelegate?

    private let viewModel: FollowerListViewModel
    private lazy var activityIndicatorView = UIActivityIndicatorView(style: .gray)

    init(viewModel: FollowerListViewModel) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundView = activityIndicatorView    // show loading for empty table view
        tableView.tableFooterView = UIView()                // for hiding separators when there is no cell
        // show a progress before fetching from network
        activityIndicatorView.startAnimating()
        viewModel.fetchFollowers { [unowned self] in
            // hide progress before fetching from network
            self.activityIndicatorView.stopAnimating()
            self.tableView.reloadData()
        }
    }

}

// MARK: - Table view data source and delegate
extension FollowerListViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.followers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator

        // FIXME: providing data to cell needs to be refactored in a way with ViewModel of cell object
        let follower = viewModel.followers[indexPath.row]
        cell.textLabel?.text = follower.login

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let follower = viewModel.followers[indexPath.row]
        delegate?.followerListViewController(self, didSelect: follower)
    }
    
}
