//
//  ViewController.swift
//  ImagePickerApp2
//
//  Created by Norris Wise on 6/21/16.
//  Copyright © 2016 Norris Swift Sample Application. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
    
{
    
    @IBOutlet weak var imageViewer: UIImageView!
    
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var imagePickerButton: UIBarButtonItem!
    @IBOutlet weak var takePhotoButton: UIBarButtonItem!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    //boolean to resize image in pickAnImage()
    var imageViewerBool = false
    var keyboardHandlerBool = false
    var yValue = CGFloat(0)
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Setup tap gestures
        setupGestures()
        setupViewAccessibilityIdentifiersForGestures()
        initializeTextFieldsWithAttributes()
        
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        setInitialButtonStates()
        
        //        unsubscribeFromKeyboardNotifications()
        
    }
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(true)
        
    }
    
    func setInitialButtonStates()
    {
        let bool = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        takePhotoButton.enabled = bool
        takePhotoButton.tag = 1
        imagePickerButton.tag = 2
        saveButton.tag = 3
        shareButton.enabled = false
        saveButton.enabled = false
    }
    
    @IBAction func pickAnImage(sender: UIBarButtonItem)
    {
        /*
         we will assign self to the myImagePivkerController 's delegate...so that
         we can use the delegates methods in our current view controller
         
         Need to implement ImagePickerControllerDelegate, and UINavigationControllerDelegate (@ class level)...
         as they are in the method signature together
         */
        let myImagePickerController = UIImagePickerController()
        
        
        
        switch(sender.tag)
        {
        case 1 :
            myImagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        case 2 :
            let bool = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
            switch(bool)
            {
            case true :
                myImagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            case false :
                myImagePickerController.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            }
        case 3 :
            savePhoto()
            
        default : return
        }
        
        myImagePickerController.delegate = self
        self.presentViewController(myImagePickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        
        let image = info [UIImagePickerControllerOriginalImage] as? UIImage
        imageViewer.image = image
        
        self.dismissViewControllerAnimated(true, completion: nil)
        //guard statement practice
        guard let _ = image where image == nil else{
            self.topTextField.userInteractionEnabled = true
            self.topTextField.enabled = true
            self.bottomTextField.userInteractionEnabled = true
            self.bottomTextField.enabled = true
            self.topTextField.hidden = false
            self.bottomTextField.hidden = false
            return
        }
        
    }
    
    //Handle Taps on the Screen to Resize the Image
    func handleGestures(sender : UITapGestureRecognizer)
    {
        print("tapped")
        let id = sender.view!.accessibilityIdentifier!
        print("id: \(id)")
        print("bool: \(imageViewerBool)")
        switch(id)
        {
        case "memePhotoImageViewer" :
            switch(imageViewerBool)
            {
            case false : imageViewer.contentMode = .ScaleAspectFit
            imageViewer.backgroundColor = UIColor.blackColor()
            imageViewerBool=true
            case true : imageViewer.contentMode = .ScaleAspectFill
            imageViewerBool=false
            }
        default:
            return
        }
    }
    
    /*
     Accessability Identifiers are setup so that the handleGestures() method knows how to handle the differrent gestures.
     This also allows editors to easily decipher what gesture belongs to the corresponding view.
     It is recommended that you DO NOT CHANGE this implementation.
     */
    func setupViewAccessibilityIdentifiersForGestures()
    {
        imageViewer.accessibilityIdentifier = "memePhotoImageViewer"
    }
    func setupGestures()
    {
        let twoTaps = UITapGestureRecognizer.init(target: self, action: #selector(ViewController.handleGestures))
        twoTaps.numberOfTapsRequired = 2
        imageViewer.userInteractionEnabled = true
        imageViewer.addGestureRecognizer(twoTaps)
    }
    
    
    /* -- OBJECT-C CLASS WILL OVERRIDE! --
     Use objective c classes. Swift classes will not throw any compiler errors, but they will override the swift class that you set for the
     text attributes
     (for stroke and fill use neg. values for NSStrokeWidthAttribute)
     */
    func initializeTextFieldsWithAttributes()
    {
        topTextField.tag = 202
        bottomTextField.tag = 808
        enableTextField("TOP", enabledTextField: topTextField)
        enableTextField("BOTTOM", enabledTextField: bottomTextField)
        topTextField.userInteractionEnabled = false
        bottomTextField.userInteractionEnabled = false
        topTextField.hidden = true
        bottomTextField.hidden = true
        topTextField.delegate = self
        bottomTextField.delegate = self
        
    }
    
    
    
    /*  ----------------- TEXT FIELD METHODS ---------------------- */
    
    
    
    
    func enableTextField(placeholderTitle : String, enabledTextField : UITextField)
    {
        let enabledTextFieldAttributes : [String : AnyObject]  =
            [
                NSStrokeColorAttributeName : UIColor.blackColor(),
                NSForegroundColorAttributeName : UIColor.whiteColor(),
                NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                NSStrokeWidthAttributeName : "-3.0",
                ]
        let enabledPlaceHolderAttributes : [String : AnyObject] =
            [
                NSStrokeColorAttributeName : UIColor.whiteColor(),
                NSForegroundColorAttributeName : UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6),
                NSStrokeWidthAttributeName : "-3.0"
        ]
        
        enabledTextField.enabled = true
        enabledTextField.userInteractionEnabled = true
        enabledTextField.attributedPlaceholder = NSAttributedString(string : placeholderTitle, attributes: enabledPlaceHolderAttributes)
        enabledTextField.defaultTextAttributes = enabledTextFieldAttributes
        enabledTextField.textAlignment = NSTextAlignment.Center
    }
    
    func disableTextField(placeholderTitle : String, disabledTextField : UITextField)
    {
        let disabledPlaceHolderAttributes : [String : AnyObject] =
            [NSForegroundColorAttributeName : UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5),
             NSStrokeColorAttributeName : UIColor.init(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5),
             NSStrokeWidthAttributeName : "-3.0"]
        disabledTextField.enabled = false
        disabledTextField.attributedPlaceholder = NSAttributedString(string : placeholderTitle, attributes: disabledPlaceHolderAttributes)
        disabledTextField.defaultTextAttributes = disabledPlaceHolderAttributes
        disabledTextField.textAlignment = NSTextAlignment.Center
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        
        
        if(textField.tag == 202)
        {
            enableTextField("TOP", enabledTextField: topTextField)
            disableTextField("BOTTOM", disabledTextField: bottomTextField)
        }
        else if (textField.tag == 808)
        {
            enableTextField("BOTTOM", enabledTextField: bottomTextField)
            disableTextField("TOP", disabledTextField: topTextField)
            subscribeToKeyboardNotifications(bottomTextField)
        }
    }
    
    @IBAction func TextFieldEditingChanged(sender: UITextField)
    {
        if( (topTextField.text!.characters.count == 0 && bottomTextField.text?.characters.count == 0))
        {
            saveButton.enabled = false
            shareButton.enabled = false
        }
        else{
            saveButton.enabled = true
            shareButton.enabled = true
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        
        enableTextField("TOP", enabledTextField: topTextField)
        enableTextField("BOTTOM", enabledTextField: bottomTextField)
        textField.resignFirstResponder()
        unsubscribeFromKeyboardNotifications(textField)
        
        
        
        return true
    }
    
    /*  ------------- TEXT FIELD METHODS END ------------------------ */
    
    func drawMeemPhoto() -> UIImage
    {
        //hide toolbars
        topToolBar.hidden = true
        bottomToolBar.hidden = true
        //size of new image
        UIGraphicsBeginImageContext(imageViewer.bounds.size)
        //get current view bounds of (specify view bounds)
        //        view.drawViewHierarchyInRect(imageViewer.frame, afterScreenUpdates: true)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        //returns image from top of the stack
        let newMeemPhoto = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        topToolBar.hidden = false
        bottomToolBar.hidden = false
        
        return newMeemPhoto
    }
    
    @IBAction func sharePhoto()
    {
        let meemPhoto = drawMeemPhoto()
        let activityViewController = UIActivityViewController.init(activityItems: [meemPhoto], applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func savePhoto()
    {
        UIImageWriteToSavedPhotosAlbum(drawMeemPhoto(), self, nil, nil)
        let savedImageAlert = UIAlertController.init(title: "Saved!", message: "Photo saved to camera roll", preferredStyle: .Alert)
        let OkAction = UIAlertAction.init(title: "OK", style: .Default, handler: nil)
        savedImageAlert.addAction(OkAction)
        self.presentViewController(savedImageAlert, animated: true, completion: nil)
    }
    
    //get keyboard Height
    func getKeyboardHeight(notification : NSNotification) -> CGFloat
    {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    //subtract keyboard height from the view's fram (y axis)
    func keyboardWillShow(notification: NSNotification)
    {
        view.frame.origin.y -= getKeyboardHeight(notification)
        
    }
    
    func keyboardWillHide()
    {
        view.frame.origin.y = 0
    }
    
    func subscribeToKeyboardNotifications(firstResponderTextField : UITextField)
    {
        //        firstResponderTextField.becomeFirstResponder()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        
        
    }
    
    func unsubscribeFromKeyboardNotifications(firstResponderTextField : UITextField) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        firstResponderTextField.resignFirstResponder()
        keyboardWillHide()
        
    }
    
}
//      unsubscribeFromKeyboardNotifications()
