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
import RealmSwift

class ProfileViewController: UIViewController {
    
    //MARK:Variables
    var userUID:String?
    var profileArray:Results<Profile>?
    let realm = try? Realm()
    
    //MARK:IBOutlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //MARK:ImageView constraints
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        profileImage.layer.masksToBounds = true
        profileImage.clipsToBounds = true
       
        //Getting data
        getData()
        
    }
    
    //MARK:Get data
    func getData(){
        profileArray = realm?.objects(Profile.self)
        userName.text = profileArray![0].user
        profileImage.image = UIImage(data: profileArray![0].imageURL)
        
    }
    
    //MARK:IBActions
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
