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
            let section = self.numberOfSections - 1
            let safeSection = section < 0 ? 0 : section
            let row = self.numberOfRows(inSection: safeSection) - 1
            let safeRow = row < 0 ? 0 : row
            let indexPath = IndexPath(row: safeRow, section: safeSection)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
}
