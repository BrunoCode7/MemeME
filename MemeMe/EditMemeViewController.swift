//
//  EditMemeViewController.swift
//  MemeMe
//
//  Created by Baraa Hesham on 1/29/19.
//  Copyright © 2019 Baraa Hesham. All rights reserved.
//

import UIKit

class EditMemeViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationItem!
    
    var memedImage: UIImage = UIImage()
    
    // helper method to configure the texfields
    
    func configureTextField(_ textField: UITextField) {
        textField.defaultTextAttributes = [
            .strokeWidth: -3.0,
            .strokeColor: UIColor.black,
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
        ]
        textField.delegate = self
        textField.textAlignment = .center

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // configure textfield settings
        
        configureTextField(topTextField)
        configureTextField(bottomTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
            // disable camera button if camera isn't available on device
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = imagePickerView.image != nil
        self.tabBarController?.tabBar.isHidden = true

        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotification()
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotification(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification,object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification,object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification){
        if bottomTextField.isFirstResponder{
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification){
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification : Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func save(){
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!,originalImage: imagePickerView.image!, memedImage:memedImage)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        hideToolBars(true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideToolBars(false)
        
        return memedImage
    }
    
    // return keyboard key hide the keyboard
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // dismiss in case user canceled picking image
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // dismiss in case user picked an image
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    // Pick image function
    
    @IBAction func pickAnImage(_ sender: UIBarButtonItem){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        switch sender.tag {
        case 0:
            pickerController.sourceType = .camera
        case 1:
            pickerController.sourceType = .photoLibrary
        default:
            print("failed to pick an Image")
        }
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(_ sender: UIBarButtonItem) {
        memedImage = generateMemedImage()
        let activityVC: UIActivityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
        
        activityVC.completionWithItemsHandler = {
            (activity, success, items, error) in
                if success {
                    self.save()
                    self.navigationController?.popToRootViewController(animated: true)

            }
        }
    }

    @IBAction func cancelMemeEdit(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    //helper method to hide toolbars
    
    func hideToolBars(_ hide:Bool){
        self.navigationController?.setNavigationBarHidden(hide, animated: false)
        toolBar.isHidden = hide
    }
    
}

