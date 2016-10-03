//
//  TextFieldDelegate.swift
//  MeMe
//
//  Created by Alexander on 10/1/16.
//  Copyright © 2016 Dictality. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate : NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.text = (textField.text == "TOP" || textField.text == "BOTTOM")
                         ? ""
                         : textField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
}
