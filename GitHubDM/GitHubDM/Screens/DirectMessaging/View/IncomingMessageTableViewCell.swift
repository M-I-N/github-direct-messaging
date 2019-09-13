//
//  IncomingMessageTableViewCell.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/13/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

class IncomingMessageTableViewCell: UITableViewCell {

    @IBOutlet private weak var incomingMessageLabel: UILabel!

    var viewModel: IncomingMessageTableViewCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            incomingMessageLabel.text = viewModel.messageBody
        }
    }

    internal static func dequeue(fromTableView tableView: UITableView, atIndex index: IndexPath) -> IncomingMessageTableViewCell {
        guard let cell: IncomingMessageTableViewCell = tableView.dequeueReusableCell(indexPath: index) else {
            fatalError("*** Failed to dequeue TableViewCell ***")
        }
        return cell
    }
    
}
