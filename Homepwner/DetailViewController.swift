//
//  DetailViewController.swift
//  Homepwner
//
//  Created by Benjamin Allgeier on 9/28/16.
//  Copyright © 2016 ballgeier. All rights reserved.
//

//import Foundation
import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    
    var item: Item! {    // adding a property observer
        didSet {
            navigationItem.title = item.name
        }
    } // end var item
    var imageStore: ImageStore!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var serialNumberField: UITextField!
    @IBOutlet var valueField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var removeImageButton: UIBarButtonItem!
    
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        
        // If the device has a camera, take a picture; otherwise,
        // just pick from photo library
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            
            // come back to this part
            // + sign is not where you want it
            // not sure why we don't initialize cameralOverlay 
            // look at discussion on forum
            let crossHair = UIButton(type: .contactAdd)
            crossHair.tintColor = UIColor.white
            crossHair.translatesAutoresizingMaskIntoConstraints = false
            imagePicker.cameraOverlayView?.addSubview(crossHair)
            imagePicker.cameraOverlayView?.isUserInteractionEnabled = false
            
            // don't understand errors without (...)! in both below
//             NSLayoutXAxisAnchor optional???
            crossHair.centerXAnchor.constraint(equalTo: (imagePicker.cameraOverlayView?.centerXAnchor)!).isActive = true
            crossHair.centerYAnchor.constraint(equalTo: (imagePicker.cameraOverlayView?.centerYAnchor)!).isActive = true
            
        } // end if
        else {
            imagePicker.sourceType = .photoLibrary
        } // end else
        
        // allow user to edit photo
        imagePicker.allowsEditing = true
        
        imagePicker.delegate = self
        
        // Place image picker on the screen
        present(imagePicker, animated: true, completion: nil)
    } // end takePicture(_:)
    
    // UIImagePickerControllerDelegate method needed to return photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Get picked image from info dictionary
//        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        // Ged edited image from info dictionary
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Store the image in the ImageStore for the item's key
        imageStore.setImage(image, forKey: item.itemKey)
        
        // this does something when selecting photo and returning 
        // to DetailViewController, but when returning
        // to this view after exiting out, the photo is not there
        // furthermore, with this commented out and redone
        // in viewWillAppear, the image is there after choosing photo
        // so below seems unnecessary as far as I can tell
        // Put that image on the screen in the image view
//        imageView.image = image
        
        // turn on removeImageButton
        removeImageButton.isEnabled = true
        
        // Take image picker off the screen -
        // You must call this dismiss method
        dismiss(animated: true, completion: nil)
    } // end imagePickerController(_:didFinishPickingMediaWithInfo:)
    
    // action triggered by Remove UIBarButtonItem
    @IBAction func removeImage(_ sender: UIBarButtonItem) {
        
        let title = "Delete \(item.name)'s Image"
        let message = "Are you sure you want to delete this image?"
        let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(cancelAction)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler:
            {(action) -> Void in
                
                //here is the meat
                
            // first delete image for item
            self.imageStore.deleteImageForKey(self.item.itemKey)
            
            // set imageView to nil
            self.imageView.image = nil
            
            // turn button off
            self.removeImageButton.isEnabled = false
        })
        ac.addAction(deleteAction)
        present(ac, animated: true, completion: nil)

    } // end removeImage

    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    } // end backgroundTapped
    
    let numberFomatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
       formatter.dateStyle = .medium
       formatter.timeStyle = .none
       return formatter
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("tapRecognizer's view is \(tapRecognizer.view)")
        
        nameField.text = item.name
        serialNumberField.text = item.serialNumber
//        valueField.text = "\(item.valueInDollars)"
//        dateLabel.text = "\(item.dateCreated)"
        valueField.text = numberFomatter.string(from: NSNumber(value: item.valueInDollars))
        dateLabel.text = dateFormatter.string(from: item.dateCreated)
        
        // Get the item key
        let key = item.itemKey
        
        // If there is an associated image with the item
        // display it on the image view
        let imageToDisplay = imageStore.imageForKey(key)
        imageView.image = imageToDisplay
        
        // if there is no image, turn off Remove image button
        if imageToDisplay == nil {
            removeImageButton.isEnabled = false
        }
        
    } // end viewWillAppear(_:)
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // The keyboard is dismissing when hitting the back button,
        // so not sure why need this
        // Clear first responder
        view.endEditing(true)
        
        // "Save changes to item
        item.name = nameField.text ?? ""
        item.serialNumber = serialNumberField.text
        
        if let valueText = valueField.text,
           let value = numberFomatter.number(from: valueText) {
            item.valueInDollars = value.intValue
        } // end if let
        else {
            item.valueInDollars = 0
        } // end else
    } // end viewWillDisappear(_:)
    
    // implement UITextFieldDelegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    } // end textFieldShouldReturn(_:)
    
    // override UIViewController method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//         If the triggered segue is the "ShowItem" segue
        // note that it all seems to work without this identifier check
        if segue.identifier == "ChangeDate" {
        
            // take advantage of DetailViewController's item
            // which is was obtained from ItemViewController
            // in ItemViewController's implementation of prepare(for:_:)
            let datePickerViewController = segue.destination as! DatePickerViewController
            datePickerViewController.item = item
            
        } // end if
    } // end prepare(for:_:)
    
} // end class DetailViewController
