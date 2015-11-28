//
//  ViewController.swift
//  SwiftKata1-SimpleCamera
//
//  Created by Phil Wright on 11/25/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var stickers = [UIImageView]()
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var imageView : UIImageView!
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Hide NavigationBar
        
        self.navigationController?.navigationBarHidden = true

        imagePicker.delegate = self
    }
    
    //MARK: - Action Methods
    
    @IBAction func addSticker() {
        
        let image = UIImage(named: "1")
        
        if let stickerImage = image {
            let imageView = PinchZoomImageView(image: stickerImage)
            self.view.addSubview(imageView)
        }
        
        
    }
    
    @IBAction func chooseImage() {
        
        if  UIImagePickerController.isSourceTypeAvailable(.Camera) {
            
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }

    //MARK: - UIImagePicker Delegate

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // Notice: UIImagePickerControllerEditedImage rather than UIImagePickerControllerOrginalImage
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            imageView.contentMode = .ScaleAspectFit
            imageView.image = pickedImage
            
            saveScreenShot()
            
            //UIImageWriteToSavedPhotosAlbum(pickedImage, self, "image:didFinishSavingWithError:contextInfo:", nil)
            
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - Saving Image
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        
        if error == nil {
            let alertController = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func saveScreenShot() {
        
        // Hide Any Views Not Relevent to Screen
        
        bottomBar.hidden = true
        
        //Create the UIImage
        UIGraphicsBeginImageContext(view.frame.size)
        self.view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Save it to the camera roll
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        // Show Any View
        bottomBar.hidden = false
        
        showAlert(title: "Saved!", message: "Your Image Was Saved to the gallery")
    }
    
    //MARK: - Helper Methods
    
    func getDocumentsDirectory() -> NSString {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func showAlert(title title: String, message: String) {
    
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }

    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }


}

