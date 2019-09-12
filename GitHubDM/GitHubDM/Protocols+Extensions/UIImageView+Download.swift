//
//  UIImageView+Download.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/12/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

private var activityIndicatorAssociationKey: UInt8 = 0

extension UIImageView {

    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        showActivityIndicator()
        URLSession.shared.dataTask(with: url) { data, response, error in
            self.hideActivityIndicator()
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }

    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }

    private var activityIndicator: UIActivityIndicatorView! {
        get {
            return objc_getAssociatedObject(self, &activityIndicatorAssociationKey) as? UIActivityIndicatorView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &activityIndicatorAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    private func showActivityIndicator() {
        if (self.activityIndicator == nil) {
            self.activityIndicator = UIActivityIndicatorView(style: .gray)
            self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            self.activityIndicator.hidesWhenStopped = true
            self.activityIndicator.isUserInteractionEnabled = false

            OperationQueue.main.addOperation({ () -> Void in
                self.addSubview(self.activityIndicator)
                self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
                self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
                self.activityIndicator.startAnimating()
            })
        }
    }


    private func hideActivityIndicator() {
        OperationQueue.main.addOperation({ () -> Void in
            self.activityIndicator.stopAnimating()
        })
    }

}
