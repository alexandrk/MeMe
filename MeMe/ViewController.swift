//
//  ViewController.swift
//  MeMe
//
//  Created by Alexander on 10/1/16.
//  Copyright © 2016 Dictality. All rights reserved.
//

import UIKit

/*
 Meme struct - keeps all the info about the meme
    - both text strings (top and bottom)
    - original image
    - meme image, with text strings applied to the image
 Note: currently not used
 */
private struct Meme {
    var textTop : String
    var textBottom : String
    var imageOriginal : UIImage
    private var imageMemed : UIImage
    
    init(_ textTop: String, textBottom: String, imageOriginal: UIImage, imageMemed: UIImage){
        self.textTop = textTop
        self.textBottom = textBottom
        self.imageOriginal = imageOriginal
        self.imageMemed = imageMemed
    }
}

class ViewController: UIViewController,
                    UIImagePickerControllerDelegate
{

    @IBOutlet private weak var toolbarTop: UIToolbar!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var toolbarBottom: UIToolbar!
    @IBOutlet private weak var pickAnImage: UIBarButtonItem!
    @IBOutlet private weak var cameraButton: UIBarButtonItem!
    @IBOutlet private weak var shareButton: UIBarButtonItem!
    @IBOutlet private weak var cancelButton: UIBarButtonItem!
    @IBOutlet private weak var textFieldTop: UITextField!
    @IBOutlet weak var textFieldBottom: UITextField!
    
    // used to save source type for image origin, based on the button clicked
    private var sourceType: UIImagePickerControllerSourceType!

    // used to prevent keyboard will hide to be called, when keyboard is not shown
    // and text fields looses focus (probably only in emulator, but doesn't hurt)
    // Note: can't be private, since it is used in the extension to the class
    var keyboardShown = false
    
    // used to store frame.origin.y value prior to moving frame upwards,
    // when keyboard shows and obstructs the bottom text field
    // Note: can't be private, since it is used in the extension to the class
    var frameOriginY: CGFloat = 0
    
    private var textFieldDelegate = TextFieldDelegate()
    
    // defaultTextAttributes - set text field characteristics such as font, text (fill) color,
    // stroke size and color (note that stoke size has a negative value in order to have both
    // stroke and and fill at the same size. Negative value also makes to be internal stroke
    private let memeTextAttributes = [
        NSStrokeColorAttributeName      : UIColor.black,
        NSStrokeWidthAttributeName      : -5,
        NSFontAttributeName             : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSForegroundColorAttributeName  : UIColor.white
        
        ] as [String : Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup for both text fields
        textFieldTop.delegate = textFieldDelegate
        textFieldTop.defaultTextAttributes = memeTextAttributes
        textFieldTop.textAlignment = .center
        
        textFieldBottom.delegate = textFieldDelegate
        textFieldBottom.defaultTextAttributes = memeTextAttributes
        textFieldBottom.textAlignment = .center
    }

    // Used to hide top status bar (the one with network, time and battery life)
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Disable camera button, if camera is not supported on the device (e.g. emulator)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        
        // Disable share button, if no image is present in the imageView.image
        shareButton.isEnabled = (imageView.image != nil) ? true : false
        
        // Subscribe to keyboard events (keyboardWill[Show|Hide]), used to shift view
        // to display the bottom text field, while entering text into it
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Clean up
        unsubscribeFromKeyboardNotifications()
    }
    
    /**
     * pickAnImage
     */
    @IBAction private func pickAnImage(_ sender: AnyObject) {
        
        let tabBarItem = sender as! UIBarButtonItem
        
        // Save an appropriate source type, based on the UITabItem clicked
        switch tabBarItem {
            case pickAnImage:
                self.sourceType = UIImagePickerControllerSourceType.photoLibrary
            case cameraButton:
                self.sourceType = UIImagePickerControllerSourceType.camera
            default:
                self.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = self.sourceType
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    /**
     * Method: imagePickerController
     * Description: Selects an image from either imagePicker or camera to be displayed in imageView
     *              Implementation of the method from UIImagePickerControllerDelegate
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
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
    
    /**
     * Method: generateMemedImaged
     */
    private func generateMemedImage() -> UIImage?
    {
        //Hide Toolbars
        toolbarTop.isHidden = true
        toolbarBottom.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show Toolbars
        toolbarTop.isHidden = false
        toolbarBottom.isHidden = false
        
        return memedImage
    }
    
    /**
     * Method: shareMeme
     * Description: generates a new meme and sends to the ActivityViewController
     *              to be shared or saved. 'shareText' used in message body, when
     *              sharing through text message
     */
    @IBAction private func shareMeme(_ sender: AnyObject) {
        let shareText = "Here is a new Meme!"
        let memeImage = generateMemedImage()
        if let image = memeImage {
            let viewController = UIActivityViewController(activityItems: [shareText, image],
                                                          applicationActivities: [])
            viewController.completionWithItemsHandler = saveMeme
            present(viewController, animated: true)
        }
    }
    
    @IBAction private func resetAppState(_ sender: AnyObject){
        textFieldTop.text = TextFieldDefaults.TOP_TEXT
        imageView.image = nil
        textFieldBottom.text = TextFieldDefaults.BOTTOM_TEXT
        
    }
    
    /**
     * Method: saveMeme
     * Description: used as a UIActivityViewControllerCompletionWithItemsHandler for shareAction ViewController
     *              displays an alert, if the action notifing weather the action was success/failure
     */
    private func saveMeme(activity: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?){
        let meme = Meme( textFieldTop.text!,
                         textBottom: textFieldBottom.text!,
                         imageOriginal: imageView.image!,
                         imageMemed: generateMemedImage()!)
        
        let viewController = UIAlertController()
        
        if (completed) {
            viewController.title = ""
            viewController.message = "Meme shared successfully!"
        }
        else {
            viewController.title = ""
            viewController.message = "Failed to share the meme. Please try again!"
        }
        
        viewController.addAction(UIAlertAction(title: "OK", style: .default){
            action in self.dismiss(animated: true, completion: nil)
        })
        
        present(viewController, animated: true)
        
    }
    
}

