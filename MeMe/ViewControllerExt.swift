//
//  ViewControllerExt.swift
//  MeMe
//
//  Created by Alexander on 10/4/16.
//  Copyright © 2016 Dictality. All rights reserved.
//

import UIKit

extension ViewController : UINavigationControllerDelegate {
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if !self.keyboardShown && textFieldBottom.isFirstResponder {
            self.frameOriginY = view.frame.origin.y
            view.frame.origin.y -= getKeyboardHeight(notification: notification)
            self.keyboardShown = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.keyboardShown {
            view.frame.origin.y = self.frameOriginY
            self.keyboardShown = false
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
}
