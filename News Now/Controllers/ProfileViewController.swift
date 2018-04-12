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
    var reachability:Reachability!
    
    //MARK:IBOutlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.reachability = Reachability.init()
        checkConnection()
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
    
    //MARK:Random functions
    func checkConnection(){
        switch self.reachability.connection {
        case .wifi:
            print("connected via wifi")
        case .cellular:
            print("connected via cellular")
        case .none:
            let alert = UIAlertController(title: "Alert", message: "No internet connection", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (_) in
                if let settingsURL = NSURL(string: UIApplicationOpenSettingsURLString + Bundle.main.bundleIdentifier!){
                    UIApplication.shared.open(settingsURL as URL)
                }
            }))
            present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    //MARK:IBActions
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
