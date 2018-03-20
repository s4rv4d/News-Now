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

class RegisterController: UIViewController {
    
    //MARK:Variables
    var emailID:String?
    var passID:String?

    //MARK:IBOutlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var regButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.borderStyle = .roundedRect
        emailTextField.borderStyle = .roundedRect
        passwordTextField.borderStyle = .roundedRect

    }

}
