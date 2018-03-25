//
//  URL_Stuff.swift
//  News Now
//
//  Created by Sarvad shetty on 3/23/18.
//  Copyright © 2018 Sarvad shetty. All rights reserved.
//

import Foundation

class newsURL{
    let url:String = "https://newsapi.org/v2/top-headlines"
    let apiKEY:String = "e0dbe7dd667541e4932545dfdf26ac3f"
    
}

class subCategories{
    
    static let shared:subCategories = subCategories()
    
    let sub:[String:[String]] = ["Technology":["ign","engadget"],"Entertainent":["mtv-news","mtv-news-uk"],"Sports":["nfl-news","espn-cric-info"],"World":["abc-news","cnn"]]
}

