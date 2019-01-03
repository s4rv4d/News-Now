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
    let apiKEY:String = "*********************************"
    
}

class subCategories{
    
    static let shared:subCategories = subCategories()
    
    let sub:[String:[String]] = ["Technology":["engadget","the-verge","techcrunch","wired","crypto-coins-news"],"Entertainent":["mtv-news","mtv-news-uk","buzzfeed","daily-mail","entertainment-weekly","mashable"],"Sports":["nfl-news","espn-cric-info","bbc-sport","bleacher-report","football-italia","fox-sports"],"World":["abc-news","cnn","bbc-news","al-jazeera-english","associated-press","fox-news","google-news","the-times-of-india"],"Gaming":["ign"],"Business":["bloomberg","business-insider","fortune","the-economist"],"Science":["new-scientist"]]
}

