//
//  EditScreenViewController.swift
//  MemeMe
//
//  Created by Justin Richardson on 2018-02-16.
//  Copyright © 2018 Justin Richardson. All rights reserved.
//

import UIKit

class EditScreenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: Image View
    @IBOutlet weak var myImageVIew: UIImageView!
    
    // MARK: Top Nav Bar
    @IBOutlet weak var navbar: UIToolbar!
    
    // MARK: Text Fields
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    // MARK: Bottom Tool Bar
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    // MARK: Text Attributes
    let memeTextAttributes: [String:Any] = [
        NSAttributedStringKey.strokeColor.rawValue:UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue:UIColor.white,
        NSAttributedStringKey.font.rawValue:UIFont(name: "HelveticaNeue-CondensedBlack", size:40)!,
        NSAttributedStringKey.strokeWidth.rawValue:-2.5
    ]
    
    // MARK: Configure Text Fields
    func configureText(textField: UITextField, withText text: String) {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.center
        textField.text = text
    }
    
    // MARK: Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        configureText(textField: topTextField, withText: "TOP")
        configureText(textField: bottomTextField, withText: "BOTTOM")
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.clearsOnInsertion = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Dismisses Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        if topTextField.text == "" {
            topTextField.text = "TOP"
        }
        if bottomTextField.text == "" {
            bottomTextField.text = "BOTTOM"
        }
    }
    
    // MARK: Photo Button
    @IBAction func shootPhoto(_ sender: UIBarButtonItem) {
        let camera = UIImagePickerController()
        camera.delegate = self
        camera.allowsEditing = false
        camera.sourceType = UIImagePickerControllerSourceType.camera
        camera.cameraCaptureMode = .photo
        camera.modalPresentationStyle = .fullScreen
        present(camera, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImage(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        myImageVIew.contentMode = .scaleAspectFit
        myImageVIew.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Generate/Save Meme
    func hideTopAndBottomBars(_ hide: Bool) {
        navBar.isHidden = hide
        navbar.isHidden = hide
    }
    
    // Combine a UIImage that combines the Image View and the Labels
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide Toolbar and Navbar
        hideTopAndBottomBars(true)
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()

        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show Tool Bar and Navbar again
        hideTopAndBottomBars(false)
        
        return memedImage
    }
    
    func save(_ memedImage: UIImage) {
        // Create the meme
        let savedMeme = Meme.init(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: myImageVIew.image!, memedImage: generateMemedImage())
        
        // Adding the image to the meme array in the AppDelegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(savedMeme)
        print(appDelegate.memes.count)
    }
    
    // MARK: Share Button
    @IBAction func shareOption(_ sender: Any) {
        let image = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(controller, animated: true, completion: nil)
        
        //calls the Save function to generate a meme object after the share activity view is dimissed
        controller.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if completed {
                self.save(image)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: Cancel Button
    @IBAction func cancelButton(_ sender: Any) {
        myImageVIew.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        dismiss(animated: true, completion: nil)
    }
    
}

