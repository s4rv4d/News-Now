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

class NewsFeedController: UIViewController {
    
    //MARK:Variables
    var userCategories:[String] = []
    var userUID:String!
    var newsFeed:[NewsFeed] = []
    var parameters:[String:String]!
    let url = newsURL()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(userCategories)
         parameters = ["sources":"ign","apiKey":url.apiKEY]
        start()
    }

    func start(){
        Alamofire.request(url.url, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess{
                let json:JSON = JSON(response.result.value!)
                print(json)
            }
        }
    }

}
