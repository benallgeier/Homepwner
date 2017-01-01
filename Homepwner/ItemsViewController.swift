//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by Benjamin Allgeier on 9/22/16.
//  Copyright © 2016 ballgeier. All rights reserved.
//

//import Foundation
import UIKit

class ItemsViewController: UITableViewController {
    
    var itemStore: ItemStore!
    var imageStore: ImageStore!
    
    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem
    } // end init?(coder:)
    
    // MARK: - View life cycle
    
    // override UIViewController method
    override func viewDidLoad() {
        print("viewDidLoad() called")
        //        // Get the height of the status bar
        //        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        //
        //        let insets = UIEdgeInsetsMake(statusBarHeight, 0, 0, 0)
        //        tableView.contentInset = insets
        //        tableView.scrollIndicatorInsets = insets
        
        //        tableView.rowHeight = 65
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    } // end viewDidLoad()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    } // end viewWillAppear(_:)
    
    // MARK: - Actions
        
    @IBAction func addNewItem(sender: AnyObject) {
//        // Make a new index path for the 0th section, last row
//        let lastRow = tableView.numberOfRows(inSection: 0)
//        let indexPath = IndexPath(row: lastRow, section: 0)
//        
//        // Insert this new row into the table
//        tableView.insertRows(at: [indexPath], with: .automatic)
        
        // the above code leads to issue with the number
        // of rows in section 0
        
        // Create a new item and add it to the store
        let newItem = itemStore.createItem()
        
        // Figure out where that item is in the array
        if let index = itemStore.allItems.index(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)
            
            // Insert this new row into the table
            tableView.insertRows(at: [indexPath], with: .automatic)
        } // end if let
        
    } // end addNewItem
    
    // override UIViewController method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If the triggered segue is the "ShowItem" segue
        if segue.identifier == "ShowItem" {
            
            // Figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                
                // Get the item associated with this row and pass along
                let item = itemStore.allItems[row]
                print("segue.source is \(segue.source)")
                print("segue.destination is \(segue.destination)")
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
                detailViewController.imageStore = imageStore
            } // end if let
        } // end if
    } // end prepare(for:_:)
    
//    @IBAction func toggleEditingMode(sender: AnyObject) {
//        // If you are currently in editing mode
//        if isEditing {
//            // Change the text of button to inform user of state
//            sender.setTitle("Edit", for: .normal)
//            
//            // Turn off editing mode
//            setEditing(false, animated: true)
//        } // end if 
//        // you are currently not in editing mode
//        else {
//            // Change text of button to inform user of state
//            sender.setTitle("Done", for: .normal)
//            
//            // Enter editing mode
//            setEditing(true, animated: true)
//        } // end else
//    
//    } // end toggleEditingMode
    
    // MARK: - UITableDataSourceMethods
    
    // override UITableViewDataSource method
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("tableView(_:commit:forRowAt) was called")
        // If the table view is asking to commit a delete command...
//        let cell = tableView.cellForRow(at: indexPath)!
//        print("Just before editingStyle == delete: cell's showReordering property is set to \(cell.showsReorderControl)")
        if editingStyle == .delete {
            
            let item = itemStore.allItems[indexPath.row]
            
            let title = "Delete \(item.name)?"
            let message = "Are you sure you want to delete this item?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive,
                                             handler: { (action) -> Void in
                // Remove the item from the store
                self.itemStore.removeItem(item: item)
                                                
                // Remove the item's image from the image store
                self.imageStore.deleteImageForKey(item.itemKey)
            
                // Also remove that row from the table view with an animation
                // ??? not getting error for not using self with tableView
                // perhaps because tableView is an argument to this function
                // ideally referencing same object
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            ac.addAction(deleteAction)
            
            // Present the alert controller
            present(ac, animated: true, completion: nil)
            
            // ask if this cell has its showReordering property set to true
//            print("Inside editingStyle == delete: cell's showReordering property is set to \(cell.showsReorderControl)")
            
            } // end if
    } // end tableView(_:commit:forRowAt)
    
    // make final row not movable
    // override UITableViewDataSource method
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        return (indexPath.section == 0) ? true : false
    } // end tableView(_:canMoveRowAt:)
    
    // override UITableViewDataSource method
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        print("tableView(_:moveRowAt:to) was called")
        print("destinationIndexPath.section is \(destinationIndexPath.section) and destinationIndexPath.row is \(destinationIndexPath.row)")

        // function call below did not work without self
        // this is a method we implement from the UITableViewDataSource protocol
        // it is just returning the size of the array itemStore.allItems
        let numberOfRows = self.tableView(tableView, numberOfRowsInSection: 0)
        print("numberOfRows (UITableDataSource method) is \(numberOfRows)")
        let numberOfRows2 = tableView.numberOfRows(inSection: 0)
        print("numberOfRows (UITable method) is \(numberOfRows2)")
        
        // Update the model
        itemStore.moveItemAtIndex(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
        
        print("Inside tableView(tableView(_:moveRowAt:to:) was called and all items:")
        itemStore.printAllItems()
        
        let numberOfRows3 = self.tableView(tableView, numberOfRowsInSection: 0)
        print("After itemStore updated: numberOfRows (UITableDataSource method) is \(numberOfRows3)")
        let numberOfRows4 = tableView.numberOfRows(inSection: 0)
        print("After itemStore updated: numberOfRows (UITable method) is \(numberOfRows4)")
        
    } // end tableView(_:moveRowAt:to)
    
    // add a section for the "No more items!" cell
    // override UITableViewDataSource protocol
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    } // end numberOfSections(in:)
    
    // override UITableViewDataSource method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableView(_:numberOfRowsInSection) was called")
        
        if section == 0 {
            return itemStore.allItems.count
        } // end if
        else if section == 1 {    // section == 1 for the row that says "No more items!"
            return 1
        } // end else if
        else {
            print("More than 2 sections!!!")
            return 0
        } // ene else
        
    } // end tableView(_:numberOfRowsInSection)
    
    // override UITableViewDataSource method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("tableView(_:cellForRowAt) called")
        // Create an instance of UITableViewCell, 
        // with default appearance
//        let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        
        // Get a new cell or recycled cell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        // Update the labels for the new preferred text size
        cell.updateLabels()
        
        if indexPath.section == 0 {
            // Set the text on the cell with the description of the
            // item that is at the nth index of items, where
            // n = row this cell will appear in on the tableview
            let item = itemStore.allItems[indexPath.row]
            
            cell.changeValueTextColor(valueInDollars: item.valueInDollars)
            
            // alternative way to change text color of valueLabel
//            if item.valueInDollars < 50 {
//                cell.changeValueTextColor(to: UIColor.green)
//            } // end if
//            else { // end else
//                cell.changeValueTextColor(to: UIColor.red)
//            }
//            cell.textLabel?.text = item.name
//            cell.detailTextLabel?.text = "$\(item.valueInDollars)"
            
            // Configure the cell with the Item
            cell.nameLabel.text = item.name
            cell.serialNumberLabel.text = item.serialNumber
            cell.valueLabel.text = "$\(item.valueInDollars)"
        } // end if
        else {   // section == 1 for cell that says "No more items!"
            // somehow, textLabel still shows up. But when we resize
            // the text from the settings, the other information disappears
            // but this method is called to initially show this item
            // so not sure how that happens
//            cell.textLabel?.text = "No more items!"
//            cell.detailTextLabel?.text = "what up"  // this didn't show up
            cell.nameLabel.text = "No more items!"
            cell.serialNumberLabel.text = ""
            cell.valueLabel.text = ""
        } // end else
        //        print("showsReorderControl is set to \(cell.showsReorderControl)")
        
        return cell
    } // end tableView(_:cellForRowAt)
    
    // Gold challenge
    // this prevents the No More Items cell from being deletable
    // override tableView(_:canEditRowAt:) method from UITableViewDataSource protocol
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (indexPath.section == 0) ? true : false
    } // end tableView(_:canEditRowAT:)
    
    // MARK: - UITableViewDelegate methods
    
    // Bronze challenge
    // override tableView(_:titleForDeleteConfirmationButtonForRowAt:) method of 
    // UITableViewDelegate protocol
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    } // end tableView(_:titleForDeleteConfirmationButtonForRowAt)
    
    // this prevents a cell being moved below the No more item cell
    // override method from UITableViewDelegate
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        print("tableView(_:targetIndexPathForMoveFromRowAt:toProposedIndexPath) was called and all items: ")
        itemStore.printAllItems()
        // desired location is still in section 0, let it happen
        if proposedDestinationIndexPath.section == 0 {
            return proposedDestinationIndexPath
        } // end if
        else {   // trying to move to section 1, put at end of section 0
            return IndexPath(row: itemStore.allItems.count - 1, section: 0)
            // alternatively, return to original position
//            return sourceIndexPath
        } // end else
    } // end tableView(_:targetIndexPathForMoveFromRowAt:toProposedIndexPath)
    
    
    // MARK: - override UIViewController methods 
    
    // could use a different prototype for "No more items!" cell
    // but see if this method stops the UIStoryboardSegue from being called
    // on that cell
    // override UIViewController method
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let section = tableView.indexPathForSelectedRow?.section {
            return (section == 0) ? true : false
        } // end if let
        // what is best way to handle this -- I don't really want to return true
        // try and catch?
        print("we shoud not be here in shouldPerformSegue(withIdentifier:_:)")
        return true
    } // end shouldPerformSegue(withIdentifier:_:)
    
} // end class ItemsViewController
