//
//  NewsFeedController.swift
//  News Now
//
//  Created by Sarvad shetty on 3/20/18.
//  Copyright © 2018 Sarvad shetty. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift
import Firebase
import SwiftKeychainWrapper

class NewsFeedController: UIViewController {
    
    //MARK:Variables
    var userCategories:[String] = []
    var userUID:String!
    var newsFeed:[NewsFeed] = []
    var parameters:[String:String]!
    let url = newsURL()
    let obj = Categories()
    let realm = try? Realm()
    var cat : Results<Categories>?
    
    
    //MARK:Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        //parameters = ["sources":"ign","apiKey":url.apiKEY]
//        print(Realm.Configuration.defaultConfiguration.fileURL)
       
    }
    override func viewDidAppear(_ animated: Bool) {
         load()
    }
    
    
    //MARK:Random functions
    func load(){
        userCategories = []
        for ca in (realm?.objects(Categories.self))!{
            userCategories = ca.category
        }
        print("user is" + "\(userCategories)")
    }
    
    //MARK:IBActions
    @IBAction func signOut(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
            KeychainWrapper.standard.removeObject(forKey: "uid")
            for ca in (realm?.objects(Categories.self))!{
                do{
                    try realm?.write {
                        realm?.delete(ca)
                    }
                }catch{
                    
                }
            }
            dismiss(animated: true, completion: nil)
        }catch{
            
        }
    }
    
}

