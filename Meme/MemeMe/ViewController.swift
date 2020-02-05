//
//  ViewController.swift
//  Meme
//
//  Created by Kay Khine win on 1/2/20.
//  Copyright © 2020 Kay Khine win. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate   {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    let DEFAULT_TOP_TEXT = "TOP TEXT"
    let DEFAULT_BOTTOM_TEXT = "BOTTOM TEXT"
     
                   
   let memeTextAttributes: [NSAttributedString.Key: Any] = [
    NSAttributedString.Key.strokeColor: UIColor.black,
    NSAttributedString.Key.foregroundColor: UIColor.white,
       NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
       NSAttributedString.Key.strokeWidth: -3.0
   ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        configureTextField(textField: topTextField)
        configureTextField(textField: bottomTextField)
        configureTapGesture()
        
       setTextField()
       
        toggleButton(isEnable: false)

    }
    private func setTextField(){
        topTextField.text = DEFAULT_TOP_TEXT
               bottomTextField.text = DEFAULT_BOTTOM_TEXT
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    private func configureTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    @objc func handleTap(){
        view.endEditing(true)
    }
    
    func subscribeToKeyboardNotifications() {
               NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
          
       }
       func unsubscribeFromKeyboardNotifications() {
       NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
           
       }
       @objc func keyboardWillShow(_ notification:Notification) {
        if (bottomTextField.isFirstResponder) {
           view.frame.origin.y -= getKeyboardHeight(notification)
       }
    }

       func getKeyboardHeight(_ notification:Notification) -> CGFloat {
           let userInfo = notification.userInfo
           let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
           return keyboardSize.cgRectValue.height
       }
       
       @objc func keyboardWillHide(_ notification:Notification) {
                  // Reset View to it's original position
                  view.frame.origin.y = 0
          }
     
       func configureTextField(textField: UITextField) -> Void{
           textField.defaultTextAttributes = memeTextAttributes
           textField.textAlignment = .center
           textField.delegate = self
        
       }
     

    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        launchImagePicker(.photoLibrary)
    }
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        launchImagePicker(.camera)
       }
    func launchImagePicker(_ source: UIImagePickerController.SourceType) {
           let imagePickerController = UIImagePickerController()
           imagePickerController.sourceType = source
           imagePickerController.delegate = self
           self.present(imagePickerController, animated: true, completion: nil)
       }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
        imagePickerView.image = image
        toggleButton(isEnable: true)
        dismiss(animated: true, completion: nil)
    }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
       }
    func textFieldDidBeginEditing(_ textField: UITextField) {
           if (topTextField == textField && topTextField.text == DEFAULT_TOP_TEXT) {
               topTextField.text = ""
           }
           if (bottomTextField == textField && bottomTextField.text == DEFAULT_BOTTOM_TEXT) {
               bottomTextField.text = ""
           }
       }
    func save() {
            // Create the meme
        _ = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: self.imagePickerView.image!, memedImage: generateMemedImage())
       
    }
       func generateMemedImage() -> UIImage {

           // TODO: Hide toolbar and navbar
           toggleBar(hide: true)
        
           // Render view to an image
           UIGraphicsBeginImageContext(self.view.frame.size)
           view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
           let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
           UIGraphicsEndImageContext()

           // TODO: Show toolbar and navbar
            toggleBar(hide: false)

           return memedImage
       }
    private func toggleBar(hide: Bool) {
        navigationBar.isHidden = hide
        toolBar.isHidden = hide
    }
    private func toggleButton(isEnable: Bool) {
       shareButton.isEnabled = isEnable
        
    }
   
    @IBAction func cancelButton(_ sender: Any) {
//              setTextField()
//              imagePickerView.image = nil
//              shareButton.isEnabled = false
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func shareAction(_ sender: Any) {
        // Create MemeObject
        let memedImage = generateMemedImage()
        let itemsToShare = [ memedImage ]
        
        // Set up activity view controller
        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        // Set completion
        activityViewController.completionWithItemsHandler = { (_, completed, _,  _) in
            if !completed {
                return
            }
        }
        // present the view controller
        self.present(activityViewController, animated: true)
    }
}


