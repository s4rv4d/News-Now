//
//  RegisterController.swift
//  News Now
//
//  Created by Sarvad shetty on 3/20/18.
//  Copyright © 2018 Sarvad shetty. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase
import FirebaseStorage
import FirebaseDatabase

class RegisterController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate {
    
    //MARK:Variables
    var emailID:String?
    var passID:String?
    var imagePickerController = UIImagePickerController()
    var imageSelected = false
    var userUID:String?

    //MARK:IBOutlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var regButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var imageVW: UIImageView!
    @IBOutlet weak var imageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.borderStyle = .roundedRect
        emailTextField.borderStyle = .roundedRect
        passwordTextField.borderStyle = .roundedRect
        emailTextField.text = emailID
        passwordTextField.text = passID
        imageVW.contentMode = .scaleAspectFill
        condition()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        observeNotification()
        
        //MARK:Constrains
        imageVW.layer.cornerRadius = imageVW.frame.size.height / 2
        imageVW.layer.masksToBounds = true
        imageVW.clipsToBounds = true
        imageVW.layer.borderWidth = 6
        imageVW.layer.borderColor = UIColor.lightGray.cgColor
        imageButton.layer.cornerRadius = imageButton.frame.size.height / 2
        imageButton.layer.masksToBounds = true
        imageButton.clipsToBounds = true
        imageButton.layer.borderWidth = 6
        imageButton.layer.borderColor = UIColor.lightGray.cgColor
        
        //MARK:Keyboard appearance
        emailTextField.keyboardAppearance = .dark
        passwordTextField.keyboardAppearance = .dark
        usernameTextField.keyboardAppearance = .dark

    }
    
    //MARK:Functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            imageVW.image = image
            imageSelected = true
        }else{
            print("image not selected")
        }
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    func condition(){
        if usernameTextField.text != "" && passwordTextField.text != "" && emailTextField.text != ""{
                regButton.isOpaque = false
           
        }else{
            regButton.isOpaque = true
        }
    }
    func uploadImg(){
        guard let image = imageVW.image, imageSelected == true else{
            print("image needs to be selected")
            let alert = UIAlertController(title: "Image needs to be selected", message: "go back", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Back", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        if let imageData = UIImageJPEGRepresentation(image, 0.2){
            let imageUID = NSUUID().uuidString
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            Storage.storage().reference().child("User_Profile_Images/"+"\(imageUID)").putData(imageData, metadata: metaData, completion: { (metadata, error) in
                if error != nil{
                    print("error uplaoding images")
                }else{
                    let downloadedURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadedURL{
                        self.setUser(url: url)
                    }
                }
            })
        }
    }
    
    func setUser(url:String){
        let userData = ["username":usernameTextField.text!,"imageurl":url]
        KeychainWrapper.standard.set(self.userUID!, forKey: "uid")
        let location = Database.database().reference().child("users").child(userUID!)
        location.setValue(userData)
        performSegue(withIdentifier: "goToCategory", sender: nil)
        
    }
    func observeNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc func keyboardShow(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: -200, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
        
    }
    @objc func keyboardHide(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField{
            usernameTextField.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    //MARK:IBActions
    @IBAction func pickImage(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose media type", message: "", preferredStyle: .alert)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let photoLibraryAction = UIAlertAction(title: "Photos", style: .default) { (_) in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        alert.addAction(cameraAction)
        alert.addAction(photoLibraryAction)
        present(alert, animated: true, completion: nil)
    }
    @IBAction func registerUser(_ sender: UIButton) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil{
                print("user can't be created")
            }else{
                if let user = user{
                    self.userUID = user.uid
                     self.uploadImg()
                }
            }
           
        }
    }
    @IBAction func goBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:Segue methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? CategoryController{
            destinationVC.userUID = self.userUID
        }
    }
}
