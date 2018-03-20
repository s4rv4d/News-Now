//
//  ViewController.swift
//  News Now
//
//  Created by Sarvad shetty on 3/18/18.
//  Copyright © 2018 Sarvad shetty. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        let arr = ["kdjsk","sdsd","dsdsd"]
//        let obj = Categories()
//        obj.category =  arr
//     //   obj.category = List(arr)
//        do{
//            try realm.write {
//                realm.add(obj)
//                print(Realm.Configuration.defaultConfiguration.fileURL)
//            }
//        }
//        catch{
//            print(error)
//        }
//     
//        
//        do{
//            try realm.write {
//                realm.delete(obj)
//                print(Realm.Configuration.defaultConfiguration.fileURL)
//            }
//        }
//        catch{
//            print(error)
//        }
//
//         print(obj.category.count)
    }


}

