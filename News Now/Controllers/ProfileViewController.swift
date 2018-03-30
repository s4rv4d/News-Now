//
//  ProfileViewController.swift
//  News Now
//
//  Created by Sarvad shetty on 3/28/18.
//  Copyright © 2018 Sarvad shetty. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class ProfileViewController: UIViewController {
    
    //MARK:Variables
    var userUID:String?

    //MARK:IBOutlets
    @IBOutlet weak var profileImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        profileImage.layer.masksToBounds = true
        profileImage.clipsToBounds = true
       
        //Getting data
        Database.database().reference().child("users").child(userUID!).observe(.value) { (dataSnapshot) in
            print(dataSnapshot)
        }
        
        
    }
    
    //MARK:IBActions
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
