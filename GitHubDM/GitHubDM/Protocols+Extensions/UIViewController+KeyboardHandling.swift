//
//  UIViewController+KeyboardHandling.swift
//  GitHubDM
//
//  Created by Nayem on 9/12/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Starts handling associated view by moving up/down with keyboard's show/hide event. Also an opposite stop func is available. Don't forget to invoke the opposite func if you somewhere invoke this func.
    func shouldStartHandlingViewForKeyboardAppearnce() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// Stops handling associated view by moving up/down with keyboard's show/hide event.
    func shouldStopHandlingViewForKeyboardAppearance() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard view.frame.origin.y == 0, let userInfo = notification.userInfo else {
            return
        }
        guard let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else {
            return
        }
        guard let keyboardAnimationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
            return
        }
        guard let keyboardAnimationCurve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue else {
            return
        }
        
        let options = UIView.AnimationOptions(rawValue: keyboardAnimationCurve << 16)
        
        UIView.animate(withDuration: keyboardAnimationDuration, delay: 0, options: options, animations: {
            self.view.frame.origin.y -= keyboardHeight
        }, completion: nil)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard view.frame.origin.y != 0, let userInfo = notification.userInfo else {
            return
        }
        guard let keyboardAnimationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
            return
        }
        guard let keyboardAnimationCurve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue else {
            return
        }
        
        let options = UIView.AnimationOptions(rawValue: keyboardAnimationCurve << 16)
        
        UIView.animate(withDuration: keyboardAnimationDuration, delay: 0, options: options, animations: {
            self.view.frame.origin.y = 0
        }, completion: nil)
    }
}
