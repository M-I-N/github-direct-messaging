//
//  UITableView+Scrolling.swift
//  GitHubDM
//
//  Created by Nayem on 9/14/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

extension UITableView {
    
    /// Scrolls to the bottom of the table view. Gets executed on the main queue.
    func scrollToBottom() {
        DispatchQueue.main.async {
            // bail out if there is no section in the table view
            guard self.numberOfSections > 0 else { return }
            // find the last section
            let lastSection = self.numberOfSections - 1
            // bail out if there is no row in the last section
            guard self.numberOfRows(inSection: lastSection) > 0 else { return }
            // find the last row of the last section
            let lastRow = self.numberOfRows(inSection: lastSection) - 1
            
            let indexPath = IndexPath(row: lastRow, section: lastSection)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
}
