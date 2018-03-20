//
//  ViewController.swift
//  News Now
//
//  Created by Sarvad shetty on 3/18/18.
//  Copyright © 2018 Sarvad shetty. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftKeychainWrapper
import Firebase

class LoginController: UIViewController, UITextFieldDelegate {
    
    //MARK:IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginInButton: UIButton!
    
    //MARK:Variables
    var userUID:String?
    
    //MARK:Private functions
    private func observeNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //MARK:Realm
    let realm = try! Realm()

    //MARK:Main functions
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextFAnchor()
        passwordTextFAnchor()
        observeNotification()

    }
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: "uid"){
            performSegue(withIdentifier: "goToNewsFeed", sender: nil)
        }
    }
    
    //MARK:Random functions
    func emailTextFAnchor(){
        emailTextField.borderStyle = .roundedRect
    }
    func passwordTextFAnchor(){
        passwordTextField.borderStyle = .roundedRect
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField{
             textField.resignFirstResponder()
        }
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK:Textfield notification properties
   @objc func keyboardShow(){
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
        self.view.frame = CGRect(x: 0, y: -120, width: self.view.frame.width, height: self.view.frame.height)
    }, completion: nil)
        
    }
   @objc func keyboardWillHide(){
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    }, completion: nil)
    }

    //MARK:IBActions
    @IBAction func loginIn(_ sender: UIButton) {
        loginInButton.isEnabled = false
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error == nil{
                self.userUID = user?.uid
                KeychainWrapper.standard.set(self.userUID!, forKey: "uid")
                self.performSegue(withIdentifier: "goToNewsFeed", sender: nil)
                self.loginInButton.isEnabled = true
            }else{
                self.performSegue(withIdentifier: "goToRegister", sender: nil)
                self.loginInButton.isEnabled = true
            }
        }
    }
    
    //MARK:Segue functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationVC = segue.destination as? RegisterController{
            destinationVC.emailID = emailTextField.text
            destinationVC.passID = passwordTextField.text
        }
    }
    
}
//        // Do any additional setup after loading the view, typically from a nib.
//        let arr = ["kdjsk","sdsd","dsdsd"]
//        let obj = Categories()
//        obj.category =  arr
//     //   obj.category = List(arr)
//        do{
//            try realm.write {
//                realm.add(obj)
//                print(Realm.Configuration.defaultConfiguration.fileURL)
//            }
//        }
//        catch{
//            print(error)
//        }
//
//
//        do{
//            try realm.write {
//                realm.delete(obj)
//                print(Realm.Configuration.defaultConfiguration.fileURL)
//            }
//        }
//        catch{
//            print(error)
//        }
//
//         print(obj.category.count)
