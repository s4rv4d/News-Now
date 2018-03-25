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
    var newsFeed2:[NewsFeed] = []
    var parameters:[String:String]!
    let url = newsURL()
    let obj = Categories()
    let realm = try? Realm()
    var cat : [String] = []
    
    
    //MARK:Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        getCat()
        getData()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
    }

    
    
    //MARK:Random functions
    func load(){
        userCategories = []
        for ca in (realm?.objects(Categories.self))!{
            userCategories = ca.category        }
        print(userCategories)
    }
    func getCat(){
        for data in userCategories{
            for data2 in subCategories.shared.sub[data]!{
                cat.append(data2)
            }
        }
    }
    func getData(){
        newsFeed = []
        for ca in cat{
            parameters = ["sources":ca,"apiKey":url.apiKEY]
            Alamofire.request(url.url, method: .get, parameters: parameters ).responseJSON(completionHandler: { (response) in
                if response.result.isSuccess{
                    let jsonVal:JSON = JSON(response.result.value!)
                    print(jsonVal)
                    self.updateDATA(json: jsonVal)
                    
                }
            })
        }
    }
    func updateDATA(json:JSON){
        let title = json["articles"][0]["title"].stringValue
        let data = json["articles"][0]["description"].stringValue
        let imgurl = json["articles"][0]["urlToImage"].stringValue
        let nwurl = json["articles"][0]["url"].stringValue
        let source = json["articles"][0]["source"]["name"].stringValue
        let nwfeed = NewsFeed(title: title, data: data, imgURL: imgurl, nwURL: nwurl, source: source)
        self.newsFeed.append(nwfeed)
        
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

