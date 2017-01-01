//
//  DatePickerController.swift
//  Homepwner
//
//  Created by Benjamin Allgeier on 9/30/16.
//  Copyright © 2016 ballgeier. All rights reserved.
//

//import Foundation
import UIKit

class DatePickerViewController: UIViewController {
    
    var item: Item!
    
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set the initial date to item's date created
        datePicker.setDate(item.dateCreated, animated: true)
        
    } // end viewWillAppear(_:)
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // "Save changes to item
        
        let date = datePicker.date
        item.dateCreated = date
        
    } // end viewWillDisappear(_:)
    
} // end class DatePickerController
