//
//  OutgoingMessageTableViewCell.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/13/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

class OutgoingMessageTableViewCell: UITableViewCell {

    @IBOutlet private weak var outgoingMessageLabel: UILabel!

    var viewModel: OutgoingMessageTableViewCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            outgoingMessageLabel.text = viewModel.messageBody
        }
    }

    internal static func dequeue(fromTableView tableView: UITableView, atIndex index: IndexPath) -> OutgoingMessageTableViewCell {
        guard let cell: OutgoingMessageTableViewCell = tableView.dequeueReusableCell(indexPath: index) else {
            fatalError("*** Failed to dequeue TableViewCell ***")
        }
        return cell
    }

}
