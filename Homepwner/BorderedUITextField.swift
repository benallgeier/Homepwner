//
//  BorderedUITextField.swift
//  Homepwner
//
//  Created by Benjamin Allgeier on 9/30/16.
//  Copyright © 2016 ballgeier. All rights reserved.
//

//import Foundation
import UIKit

class BorderedUITextField: UITextField {
    
    override func becomeFirstResponder() -> Bool {
        // http://stackoverflow.com/questions/34985404/calling-resignfirstresponder-doesnt-work-within-overrides-firstresponder
        // this recommends letting a local constant be
        // super.becomeFirstResponder()
        // and return that variable at end
        // to pass messages along
        
//        super.becomeFirstResponder()
        let becomeFirstResponder = super.becomeFirstResponder()
        
//        print("this button can become First responder: \(canBecomeFirstResponder)")
//        print("this button can resign first responder: \(canResignFirstResponder)")
        
        borderStyle = .bezel
        
//        self.layer.cornerRadius = 5.0
//        self.layer.borderColor = UIColor.orange.cgColor
//        self.layer.borderWidth = 0.5
        
//        return true
        return becomeFirstResponder
        
    } // end becomeFirstResponder()
    
    override func resignFirstResponder() -> Bool {
//        super.resignFirstResponder()
        let resignFirstResponder = super.resignFirstResponder()
        
//        borderStyle = .none      // this does not work!!!
        borderStyle = .roundedRect
        
//        self.layer.borderColor = UIColor.lightGray.cgColor
//        self.layer.borderWidth = 0.1
//        // not sure about the original settings
//        // also should change the cornerRadius back
        
//        return true
        return resignFirstResponder
        
    } // end resignFirstResponder()
    
} // end BorderedUITextField
