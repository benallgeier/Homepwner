//
//  ItemCell.swift
//  Homepwner
//
//  Created by Benjamin Allgeier on 9/27/16.
//  Copyright © 2016 ballgeier. All rights reserved.
//

//import Foundation
import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var serialNumberLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    func updateLabels() {
        let bodyFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        nameLabel.font = bodyFont
        valueLabel.font = bodyFont
        
        let captionFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        serialNumberLabel.font = captionFont
    
    } // end updateLabels()
    
    // this works
    // but you have to put in a color
    func changeValueTextColor(to color: UIColor) {
        valueLabel.textColor = color
    } // end changeValueTextColor(to:)
    
    // here is another approach -- take in a number
    func changeValueTextColor(valueInDollars value: Int) {
        if value < 50 {
            valueLabel.textColor = UIColor.green
        } // end if 
        else {
            valueLabel.textColor = UIColor.red
        } // end else
    } // end changeValueTextColor(valueInDollars:)
    
} // end class ItemCell
