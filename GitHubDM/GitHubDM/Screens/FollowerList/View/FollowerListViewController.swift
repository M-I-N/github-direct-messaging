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
        removeNavigationBarBackButtonTitle()
        tableView.registerReusableCell(FollowerTableViewCell.self)
        tableView.backgroundView = activityIndicatorView    // show loading for empty table view
        tableView.rowHeight = 80
        tableView.separatorStyle = .none                    // separator is handled from the cell design itself
        // show a progress before fetching from network
        activityIndicatorView.startAnimating()
        viewModel.fetchFollowers()
        viewModel.onAvailabilityOfNewFollowers = { [unowned self] in
            if self.activityIndicatorView.isAnimating {
                self.activityIndicatorView.stopAnimating()
            }
            self.tableView.reloadData()
        }
    }

}

// MARK: - Table view data source and delegate
extension FollowerListViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfFollowers(in: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FollowerTableViewCell.dequeue(fromTableView: tableView, atIndex: indexPath)

        let follower = viewModel.follower(at: indexPath)
        cell.viewModel = FollowerTableViewCellViewModel(follower: follower)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let follower = viewModel.selectedFollower(at: indexPath)
        delegate?.followerListViewController(self, didSelect: follower)
    }
    
}
