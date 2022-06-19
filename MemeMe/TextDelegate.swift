//
//  TextDelegate.swift
//  MemeMe
//
//  Created by Vishnu V on 16/06/22.
//

import Foundation
import UIKit

class TextDelegate : NSObject, UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
