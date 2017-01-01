//
//  Item.swift
//  Homepwner
//
//  Created by Benjamin Allgeier on 9/22/16.
//  Copyright © 2016 ballgeier. All rights reserved.
//

//import Foundation
import UIKit

class Item: NSObject, NSCoding {
    var name: String
    var valueInDollars: Int
    var serialNumber: String?
    var dateCreated: Date
    let itemKey: String
    
    // designated initializer -- need at least one
    // calls super.init -- note its after initialization of properties
    init(name: String, serialNumber: String?, valueInDollars: Int) {
        self.name = name
        self.valueInDollars = valueInDollars
        self.serialNumber = serialNumber
        self.dateCreated = Date()
        self.itemKey = NSUUID().uuidString
        
        super.init()
    } // end init
    
    // convenience initializer
    // note each branch calls designated initializer
    convenience init(random: Bool = false) {
        if random {
            let adjectives = ["Fluffy", "Rusty", "Shiny"]
            let nouns = ["Bear", "Spork", "Mac"]
            
            // number literals will be converted to UInt32
            // inside arc4random_uniform call
            // otherwise we cast
            var idx =
                arc4random_uniform(UInt32(adjectives.count))
            let randomAdective = adjectives[Int(idx)]
            
            idx = arc4random_uniform(UInt32(nouns.count))
            let randomNounn = nouns[Int(idx)]
            
            let randomName = "\(randomAdective) \(randomNounn)"
            let randomValue = Int(arc4random_uniform(100))
            let randomSerialNumber = NSUUID().uuidString.components(separatedBy: "-").first!
            
            self.init(name: randomName,
                      serialNumber: randomSerialNumber,
                      valueInDollars: randomValue)
        } // end if
        else {
            self.init(name: "", serialNumber: nil, valueInDollars: 0)
        } // end else
    } // end convenience init
    
    // MARK: - NSCoding methods
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(dateCreated, forKey: "dateCreated")
        aCoder.encode(itemKey, forKey: "itemKey")
        aCoder.encode(serialNumber, forKey: "serialNumber")
        aCoder.encode(valueInDollars, forKey: "valueInDollars")
    } // end encode(with:)
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        dateCreated = aDecoder.decodeObject(forKey: "dateCreated") as! Date
        itemKey = aDecoder.decodeObject(forKey: "itemKey") as! String
        serialNumber = aDecoder.decodeObject(forKey: "serialNumber") as! String?
         // app crashed with method below
//        valueInDollars = aDecoder.decodeObject(forKey: "valueInDollars") as! Int
        valueInDollars = aDecoder.decodeInteger(forKey: "valueInDollars")
    }
    
} // end class Item
