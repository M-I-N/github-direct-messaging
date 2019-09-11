//
//  FollowersListViewController.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/11/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

class FollowersListViewController: UITableViewController {

    private let viewModel: FollowerListViewModel

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
    }

}

// MARK: - Table view data source
extension FollowersListViewController {

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
    
}
