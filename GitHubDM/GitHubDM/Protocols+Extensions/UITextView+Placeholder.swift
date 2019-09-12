//
//  UITextView+Placeholder.swift
//  GitHubDM
//
//  Created by Nayem on 9/12/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

/// This implementation is inspired and taken from https://stackoverflow.com/a/50671026/3687801

import UIKit

extension UITextView {
    
    private class PlaceholderLabel: UILabel { }
    
    private var placeholderLabel: PlaceholderLabel {
        if let label = subviews.compactMap( { $0 as? PlaceholderLabel }).first {
            return label
        } else {
            let label = PlaceholderLabel(frame: .zero)
            label.font = font
            addSubview(label)
            return label
        }
    }
    
    /// Used for maintaining a padding when placeholder is used.
    private var horizontalPadding: CGFloat {
        // Return a constant value from here.
        return 20
    }
    
    @IBInspectable
    var placeholder: String {
        get {
            return self.placeholderLabel.text ?? ""
        }
        set {
            textContainer.lineFragmentPadding = horizontalPadding
            let placeholderLabel = self.placeholderLabel
            placeholderLabel.text = newValue
            placeholderLabel.numberOfLines = 0
            let width = frame.width - textContainer.lineFragmentPadding * 2
            let size = placeholderLabel.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
            placeholderLabel.frame.size.height = size.height
            placeholderLabel.frame.size.width = width
            placeholderLabel.frame.origin = CGPoint(x: textContainer.lineFragmentPadding, y: textContainerInset.top)
            
            textStorage.delegate = self
        }
    }
    
    @IBInspectable
    var placeholderTextColor: UIColor {
        get {
            return self.placeholderLabel.textColor
        }
        set {
            self.placeholderLabel.textColor = newValue
        }
    }
    
}

extension UITextView: NSTextStorageDelegate {
    
    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
        if editedMask.contains(.editedCharacters) {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }
    
}
