//
//  TextFieldDelegate.swift
//  MeMe
//
//  Created by Alexander on 10/1/16.
//  Copyright © 2016 Dictality. All rights reserved.
//

import Foundation
import UIKit

struct TextFieldDefaults {
    static let TOP_TEXT = "TOP"
    static let BOTTOM_TEXT = "BOTTOM"
}

class TextFieldDelegate : NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.text = (textField.text == TextFieldDefaults.TOP_TEXT ||
                          textField.text == TextFieldDefaults.BOTTOM_TEXT)
                             ? ""
                             : textField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
}
