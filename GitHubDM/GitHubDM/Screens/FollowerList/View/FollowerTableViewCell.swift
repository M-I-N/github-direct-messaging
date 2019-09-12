//
//  FollowerTableViewCell.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/12/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

class FollowerTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var profileImageView: UIImageView!

    var viewModel: FollowerTableViewCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            userNameLabel.text = viewModel.formattedAsGitHubHandle
            profileImageView.downloaded(from: viewModel.imageURL, contentMode: .scaleAspectFill)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 5
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
    }

    internal static func dequeue(fromTableView tableView: UITableView, atIndex index: IndexPath) -> FollowerTableViewCell {
        guard let cell: FollowerTableViewCell = tableView.dequeueReusableCell(indexPath: index) else {
            fatalError("*** Failed to dequeue TableViewCell ***")
        }
        return cell
    }
    
}
