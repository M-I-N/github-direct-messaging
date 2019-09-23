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

    private var viewModel: FollowerListViewModel
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
        tableView.dataSource = viewModel.dataSource
        tableView.registerReusableCell(FollowerTableViewCell.self)
        tableView.backgroundView = activityIndicatorView    // show loading for empty table view
        tableView.rowHeight = 80
        tableView.separatorStyle = .none                    // separator is handled from the cell design itself
        // show a progress before fetching from network
        activityIndicatorView.startAnimating()
        viewModel.fetchFollowers()
        viewModel.dataSource.data.addAndNotify(observer: self) { [unowned self] _ in
            if self.activityIndicatorView.isAnimating {
                self.activityIndicatorView.stopAnimating()
            }
            self.tableView.reloadData()
        }
        viewModel.onErrorHandling = { [unowned self] title, message in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alertController, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let follower = viewModel.dataSource.data.value[indexPath.row]
        delegate?.followerListViewController(self, didSelect: follower)
    }

}
