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
import iProgressHUD

class LoginController: UIViewController, UITextFieldDelegate {
    
    //MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginInButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    //MARK: - Variables
    var userUID:String?
    var arr:[String] = []
    let obj = Categories()
    var reachability:Reachability!
    let imagesArray = ["background","background2","background3","background4","background5","background6","background7"]
    
    //MARK: - Private functions
    private func observeNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //MARK: - Realm
    let realm = try! Realm()

    //MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reachability = Reachability.init()
        let iprogressHUD = iProgressHUD()
        iprogressHUD.attachProgress(toView: self.view)
        iprogressHUD.indicatorStyle = .ballZigZag
        iprogressHUD.iprogressStyle = .horizontal
        observeNotification()
        emailTextField.keyboardAppearance = .dark
        passwordTextField.keyboardAppearance = .dark
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(handle), userInfo: nil, repeats: true)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: "uid"){
            checkConnection()
            performSegue(withIdentifier: "goToNewsFeed", sender: nil)
        }else{
            checkConnection()
        }
    }

    
    //MARK: - Random functions
    @objc func handle(_ timer:Timer){
        let randomNumber = Int(arc4random_uniform(UInt32(imagesArray.count)))
        let imageName:String = imagesArray[randomNumber] as String
        UIView.transition(with: backgroundImageView, duration: 0.7, options: [.transitionFlipFromTop], animations: {
            self.backgroundImageView.image = UIImage(named: imageName)
        }, completion: nil)
        
        
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
    
    //MARK: - Textfield notification properties
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
    func checkConnection(){
        switch self.reachability.connection {
        case .wifi:
            print("connected via wifi")
        case .cellular:
            print("connected via cellular")
        case .none:
            print("hhihi")
            let alert = UIAlertController(title: "Alert", message: "No internet connection", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (_) in
                if let settingsURL = NSURL(string: UIApplicationOpenSettingsURLString + Bundle.main.bundleIdentifier!){
                    UIApplication.shared.open(settingsURL as URL)
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }

    //MARK: - IBActions
    @IBAction func loginIn(_ sender: UIButton) {
        loginInButton.isEnabled = false
        view.showProgress()
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error == nil{
                self.userUID = user?.uid
                KeychainWrapper.standard.set(self.userUID!, forKey: "uid")
                // * for next login
                DispatchQueue.main.async {
                    Database.database().reference().child("categories").child(self.userUID!).observe(.value, with: { (snapshot) in
                        if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                            self.arr = []
                            for data in snapshot{
                                self.arr.append(data.value! as! String)
                            }
                            self.obj.category = self.arr
                            do{
                                try self.realm.write {
                                    self.realm.add(self.obj)
                                    self.view.dismissProgress()
                                    self.emailTextField.text = ""
                                    self.passwordTextField.text = ""
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
                
                self.view.dismissProgress()
                let alert = UIAlertController(title: "Error", message: "Invalid Credentials", preferredStyle: .alert)
                let action = UIAlertAction(title: "Done", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                self.loginInButton.isEnabled = true
            }
        }
    }
    @IBAction func goToRegister(_ sender: UIButton) {}
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue){}
    
    //MARK: - Segue functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationVC = segue.destination as? RegisterController{
            destinationVC.emailID = emailTextField.text
            destinationVC.passID = passwordTextField.text
            emailTextField.text = ""
            passwordTextField.text = ""
        }
        else if let destinationVC2 = segue.destination as? NewsFeedController{
            destinationVC2.userUID = KeychainWrapper.standard.string(forKey: "uid")
        }
    }
    
}

