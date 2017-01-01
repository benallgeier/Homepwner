//
//  ItemStore.swift
//  Homepwner
//
//  Created by Benjamin Allgeier on 9/22/16.
//  Copyright © 2016 ballgeier. All rights reserved.
//

//import Foundation
import UIKit

class ItemStore {          // note this is a base class
                           // not a subclass of NSObject
    var allItems = [Item]()
    
    let itemArchiveURL: URL = {
       let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
       let documentDirectory = documentsDirectories.first!
       return documentDirectory.appendingPathComponent("items.archive")
    }()
        
    func createItem() -> Item {
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        
        return newItem
    } // end createItem()
    
    init() {
        if let archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: itemArchiveURL.path) as? [Item] {
            allItems += archivedItems
        } // end if let
    } // end init
    
//    init() {
//        for _ in 0..<5 {
//            _ = createItem()
//        } // end for
//    } // end init()
    
    func removeItem(item: Item) {
        if let index = allItems.index(of: item) {
            allItems.remove(at: index)
        } // end if let
    } // end removeItem(_)
    
    func moveItemAtIndex(fromIndex: Int, toIndex: Int) {
        if fromIndex == toIndex {
            return
        } // end if
        
        let movedItem = allItems[fromIndex]
        
        // Remove item from array
        allItems.remove(at: fromIndex)
        
        // Insert item in array at new location
        allItems.insert(movedItem, at: toIndex)
    } // end moveItemAtIndex
    
    func printAllItems() {
        for item in allItems {
            print("item.name is \(item.name)")
        } // end for
    } // end printAllItems
    
    func saveChanges() -> Bool {
        print("Saving items to: \(itemArchiveURL.path)")
        return NSKeyedArchiver.archiveRootObject(allItems, toFile: itemArchiveURL.path)
    } // end saveChanges()
    
} // end class ItemStore
