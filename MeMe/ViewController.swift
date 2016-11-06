//
//  ViewController.swift
//  MeMe
//
//  Created by Alexander on 10/1/16.
//  Copyright © 2016 Dictality. All rights reserved.
//

import UIKit

class ViewController: UIViewController,
                    UIImagePickerControllerDelegate
{
    // MARK: - Property Definitions: Variables and Constants
    @IBOutlet private weak var toolbarTop: UIToolbar!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var toolbarBottom: UIToolbar!
    @IBOutlet private weak var pickAnImage: UIBarButtonItem!
    @IBOutlet private weak var cameraButton: UIBarButtonItem!
    @IBOutlet private weak var shareButton: UIBarButtonItem!
    @IBOutlet private weak var cancelButton: UIBarButtonItem!
    @IBOutlet private weak var textFieldTop: UITextField!
    @IBOutlet weak var textFieldBottom: UITextField!
    @IBOutlet weak var topTextTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomTextBottomConstraint: NSLayoutConstraint!
    
    private var navBarsHeight: Double!
    
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
    
    // MARK: - View Controller LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup for both text fields
        stylizeTextField(textField: textFieldTop)
        stylizeTextField(textField: textFieldBottom)
        
        if self.navBarsHeight == nil {
            self.navBarsHeight = Double(UIScreen.main.bounds.height) - Double(imageView.frame.size.height)
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
     * Method: viewWillTransition
     * Description: Called on screen rotation to adjust text fields position over the image
     */
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        // Checking if the viewController is loaded and attached to the window (is displayed)
        // Prevents the code to be executed on screen rotation, if this viewControler is not on screen
        if (self.isViewLoaded && self.view.window != nil){
            adjustTextFieldsPosition(screenDimensions: size)
        }
    }
    
    // Used to hide top status bar (the one with network, time and battery life)
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    // MARK: IBActions
    
    /**
     * Method: pickAnImage
     * Description: Presents an ImagePicker view
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
    
    /**
     * Method: resetAppState
     * Description: 'cancel' button action
     */
    @IBAction private func resetAppState(_ sender: AnyObject){
        dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: Delegates
    
    /**
     * Method: imagePickerController (imagePickerController DELEGATE)
     * Description: Selects an image from either imagePicker or camera to be displayed in imageView
     *              Implementation of the method from UIImagePickerControllerDelegate
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let selectedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imageView.image = selectedImage
            picker.dismiss(animated: true, completion: nil)

            adjustTextFieldsPosition(screenDimensions: nil)
            
        }
    }
    
    // MARK: HELPER
    
    /**
     * Method: scaledImageDimensions
     * Description: Returns the scaled size of the loaded image
     */
    private func scaledImageDimensions(_ imageView: UIImageView, _ size: CGSize?) -> CGSize{
        
        var frameWidth: Double!
        var frameHeight: Double!
        var scaledSize: CGSize!
        
        // Size is passed on screen rotation, nil otherwise
        if size == nil {
            frameWidth  = Double(imageView.frame.size.width)
            frameHeight = Double(imageView.frame.size.height)
        }
        else {
            frameWidth = Double(size!.width)
            frameHeight = Double(size!.height) - self.navBarsHeight
        }
        
        //Original Dimensions of the loaded Image
        let imgWidth    = Double(imageView.image!.size.width)
        let imgHeight   = Double(imageView.image!.size.height)
        
        let sx = frameWidth / imgWidth
        let sy = frameHeight / imgHeight
        
        //
        if imgWidth > imgHeight && frameWidth < frameHeight {
            scaledSize = CGSize (width: frameWidth, height: sx * imgHeight)
        }
        else {
            scaledSize = CGSize (width: sy * imgWidth, height: frameHeight)
        }
        return scaledSize

    }
    
    /**
     * Method: adjustTextFieldsPosition
     * Description: Adjusts text fields to go over a loaded image
     */
    private func adjustTextFieldsPosition(screenDimensions size: CGSize?){
        
        let imageViewHeight = (size != nil)
            ? Double((size?.height)!) - self.navBarsHeight
            : Double(imageView.bounds.height)
        
        // Get scaled image dimensions (uses UIImageView extension)
        let imgScaledDimensions = scaledImageDimensions(imageView, size)
        let textPaddingFromImageEdge = 10.0
        
        // Calculating 'y' for top of loaded image and using it for textFields constraints values
        let halfOfLoadedImage = Double(imgScaledDimensions.height) / 2
        let topOfImageInView = imageViewHeight / 2 - halfOfLoadedImage
        let newConstraintValue = topOfImageInView + textPaddingFromImageEdge
        
        // Set textField constraints accordingly
        topTextTopConstraint.constant = CGFloat(-newConstraintValue)
        bottomTextBottomConstraint.constant = CGFloat(newConstraintValue)
    }
    
    /**
     * Method:getMemeImageDimensions
     * Description: Creates a CGRect object to be used for image cropping,
     *              when saving / sharing created Meme
     */
    private func getMemeImageDimensions() -> CGRect{
        
        let screenCenter = ["x": view.bounds.width / 2, "y": view.bounds.height / 2]
        let imgScaledDimensions = scaledImageDimensions(imageView, nil)
        
        return CGRect(x: screenCenter["x"]! - imgScaledDimensions.width / 2,
                      y: screenCenter["y"]! - imgScaledDimensions.height / 2,
                      width: imgScaledDimensions.width,
                      height: imgScaledDimensions.height)
    }
    
    /**
     * Method: generateMemedImaged
     * Description: Creates a memed image and returns it
     */
    private func generateMemedImage() -> UIImage?
    {
        let memeFrame: CGRect = getMemeImageDimensions()
        
        // Render whole view to an image (screenshot)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let memedImage : UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Crop ScreenShot to MemedImage dimensions
        let croppedMeme = UIImage(cgImage: (memedImage?.cgImage?.cropping(to: memeFrame))!)
        
        return croppedMeme
    }
    
    /**
     * Method: stylizeTextField
     * Description: Used to setup both textfields with proper delegate and styling
     */
    private func stylizeTextField(textField: UITextField) {
        textField.delegate = textFieldDelegate
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    /**
     * Method: saveMeme
     * Description: used as a UIActivityViewControllerCompletionWithItemsHandler for shareAction ViewController
     *              displays an alert, if the action notifing weather the action was success/failure
     */
    private func saveMeme(activity: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?){
        
        let alertVC = UIAlertController()
        
        if (completed) {
            
            // Save the Meme within the app structure, if completed is TRUE
            let meme = Meme( textTop:       textFieldTop.text!,
                             textBottom:    textFieldBottom.text!,
                             imageOriginal: imageView.image!,
                             imageMemed:    generateMemedImage()!)
            
            // Add it to the memes array in the Application Delegate
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.append(meme)
            
            alertVC.title = ""
            alertVC.message = "Meme shared successfully!"
        }
        else {
            alertVC.title = ""
            alertVC.message = "Failed to share the meme. Please try again!"
        }
        
        alertVC.addAction(UIAlertAction(title: "OK", style: .default){
            action in self.dismiss(animated: true, completion: nil)
        })
        
        present(alertVC, animated: true)
        
    }
    
}

