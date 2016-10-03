//
//  ViewController.swift
//  MeMe
//
//  Created by Alexander on 10/1/16.
//  Copyright © 2016 Dictality. All rights reserved.
//

import UIKit

class ViewController: UIViewController,
                    UIImagePickerControllerDelegate,
                    UINavigationControllerDelegate
{

    @IBOutlet weak var pickAnImage: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var textFieldBottom: UITextField!
    private var sourceType: UIImagePickerControllerSourceType!
    private var keyboardShown = false
    private var frameOriginY: CGFloat = 0
    
    var textFieldDelegate = TextFieldDelegate()
    
    // defaultTextAttributes
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : 3
        ] as [String : Any]
            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        textFieldTop.delegate = textFieldDelegate
        textFieldTop.defaultTextAttributes = memeTextAttributes
        textFieldTop.textAlignment = .center
        
        textFieldBottom.delegate = textFieldDelegate
        textFieldBottom.defaultTextAttributes = memeTextAttributes
        textFieldBottom.textAlignment = .center
    }

    override func viewWillAppear(_ animated: Bool) {
        
        // Disable camera button, if camera is not supported on the device (e.g. emulator)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        
        // Subscribe to keyboard events (keyboardWillShow), used to shift displayView
        // to display the bottom text field, while entering text into it
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    @IBAction func pickAnImage(_ sender: AnyObject) {
        
        let tabBarItem = sender as! UIBarButtonItem
        
        // Save an appropriate source type, based on the UITabItem clicked
        switch tabBarItem.tag {
            case 0:
                self.sourceType = UIImagePickerControllerSourceType.photoLibrary
            case 1:
                self.sourceType = UIImagePickerControllerSourceType.camera
            default:
                self.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        let imageView = UIImagePickerController()
        imageView.delegate = self
        
        self.present(imageView, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.sourceType = self.sourceType
        
        if let selectedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imageView.image = selectedImage
            picker.dismiss(animated: true, completion: nil)

/*
            // Adjust text fields to go over an image
            
            // 1. Get imageView center x, y
            let imageViewY = Double(imageView.frame.origin.y)
            let imageViewHeight = Double(imageView.frame.height)
            
            // 2. Get scaled image dimensions (uses UIImageView extension)
            let imgScaledDimensions = imageView.scaledImageDimensions
            
            // 3. Calculating 'y' of top text field (with textPaddingFromImageEdge)
            let textPaddingFromImageEdge = 10.0
            let topOfImgInView = imageViewHeight / 2 - Double(imgScaledDimensions.height) / 2
            
            textFieldTop.translatesAutoresizingMaskIntoConstraints = true
            //textFieldTop.frame.origin.y = CGFloat(imageViewY + topOfImgInView + textPaddingFromImageEdge)
            
            // 4. bottom text y = imageView.center.y + height / 2 - (textSpacingFromImageEdge)
*/
            
            
        }
    }

    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name:
                                    NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:
                                    NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if !self.keyboardShown {
            self.frameOriginY = view.frame.origin.y
            view.frame.origin.y -= getKeyboardHeight(notification: notification)
            self.keyboardShown = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.keyboardShown {
            view.frame.origin.y = self.frameOriginY
            self.keyboardShown = false
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
}

