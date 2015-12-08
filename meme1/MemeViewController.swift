//
//  ViewController.swift
//  meme1
//
//  Created by Evan Scharfer on 12/4/15.
//  Copyright © 2015 Evan Scharfer. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]

    @IBOutlet weak var mainImage: UIImageView!
    
    @IBOutlet weak var topText: UITextField!
    
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    var memedImage : UIImage?
    
    var meme : Meme?
    
    var memeLocation : Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setTextAttribute(topText)
        setTextAttribute(bottomText)
        shareButton.enabled = false
        
        //disable camera if not avaialbe
        if (!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            cameraButton.enabled = false
        }
        
        // if edit / details screen
        if let meme = meme {
            bottomText.text = meme.bottomText
            topText.text = meme.topText
            mainImage.contentMode = UIViewContentMode.ScaleAspectFit
            mainImage.image = meme.originalImage
            shareButton.enabled = true
        }
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        if let tabBar = tabBarController?.tabBar {
            tabBar.hidden = true
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        if let tabBar = tabBarController?.tabBar {
            tabBar.hidden = false
        }
    }
    
    @IBAction func showAlbum(sender: AnyObject) {
    
        showImagePicker(UIImagePickerControllerSourceType.PhotoLibrary)
        
    }
    
    @IBAction func showCamera(sender: AnyObject) {
        
        showImagePicker(UIImagePickerControllerSourceType.Camera)
        
    }
    
    func setTextAttribute(text : UITextField) {
        text.delegate = self
        text.defaultTextAttributes = memeTextAttributes
        text.textAlignment = NSTextAlignment.Center
    }
    
    func showImagePicker(type : UIImagePickerControllerSourceType) {
        
        // show image picker for the type given
        let imageController = UIImagePickerController()
        imageController.delegate = self
        imageController.sourceType = type
        presentViewController(imageController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        mainImage.contentMode = UIViewContentMode.ScaleAspectFit
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            mainImage.image = image
            shareButton.enabled = true
        }
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        textField.text = ""
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if (bottomText.isFirstResponder()) {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    
    @IBAction func shareMeme(sender: AnyObject) {
        
        memedImage = generateMemedImage()
        
        if let memedImage = memedImage {
            let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
            
            activityController.completionWithItemsHandler = { activity, success, items, error in
                // user has completed
                self.shareFinished(activity, success: success, items: items, error: error)
                
            }
            
            presentViewController(activityController, animated: false, completion: nil)
        }
        
        
    }
    
    @IBAction func cancelMeme(sender: AnyObject) {
        // reset screen
        mainImage.image = nil
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        shareButton.enabled = false
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    func generateMemedImage() -> UIImage
    {
        navigationController?.setNavigationBarHidden(true, animated: false)
        bottomToolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        bottomToolbar.hidden = false
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        return memedImage
    }

    func shareFinished(shareActivity : String?, success: Bool, items: [AnyObject]?, error : NSError?) {
        
        let meme = Meme( topText: topText.text!, bottomText: bottomText.text!, originalImage:
            mainImage.image!, memedImage: memedImage!)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        
        // append or edit to memes
        if let memeLocation = memeLocation {
            appDelegate.memes[memeLocation] = meme
        } else {
            appDelegate.memes.append(meme)
        }
        
        navigationController?.popViewControllerAnimated(true)
        
    }
    


}

