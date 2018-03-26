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
import FirebaseDatabase

class LoginController: UIViewController, UITextFieldDelegate {
    
    //MARK:IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginInButton: UIButton!
    
    //MARK:Variables
    var userUID:String?
    var arr:[String] = []
    let obj = Categories()
    
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
//        emailTextFAnchor()
//        passwordTextFAnchor()
        observeNotification()
        emailTextField.keyboardAppearance = .dark
        passwordTextField.keyboardAppearance = .dark

    }
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: "uid"){
            performSegue(withIdentifier: "goToNewsFeed", sender: nil)
     }
    }

    
    //MARK:Random functions
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
                // * for next login
                DispatchQueue.main.async {
                    Database.database().reference().child("categories").child(self.userUID!).observe(.value, with: { (snapshot) in
                        if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                            //print(snapshot)
                            self.arr = []
                            for data in snapshot{
                                self.arr.append(data.value! as! String)
                            }
                            print("its is" + "\(self.arr)")
                            self.obj.category = self.arr
                            do{
                                try self.realm.write {
                                    self.realm.add(self.obj)
                                    self.performSegue(withIdentifier: "goToNewsFeed", sender: nil)
                                    self.loginInButton.isEnabled = true
                                }
                            }catch{
                            }
                            
                        }
                    })
                }
                
                //*
               
            }else{
                self.performSegue(withIdentifier: "goToRegister", sender: nil)
                self.loginInButton.isEnabled = true
            }
        }
    }
    @IBAction func goToRegister(_ sender: UIButton) {
        //nothing for now
    }
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue){
        
    }
    
    //MARK:Segue functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationVC = segue.destination as? RegisterController{
            destinationVC.emailID = emailTextField.text
            destinationVC.passID = passwordTextField.text
            emailTextField.text = ""
            passwordTextField.text = ""
        }
    }
    
}

