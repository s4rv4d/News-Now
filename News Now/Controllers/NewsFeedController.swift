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
import SDWebImage

class NewsFeedController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
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
    var url2:URL?
    
    //MARK:IBOutlets
    @IBOutlet weak var collectionVW: UICollectionView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    
    //MARK:Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        getCat()
        getData()
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(NewsFeedController.handleSwipe(_:)))
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(NewsFeedController.handleSwipe(_:)))
        upSwipe.direction = .up
        downSwipe.direction = .down
        view.addGestureRecognizer(upSwipe)
        view.addGestureRecognizer(downSwipe)
        
        print(userUID)
        
    }
    
    
    //MARK:Random functions
    @objc func handleSwipe(_ sender:UISwipeGestureRecognizer){
        if sender.direction == .up{
            let layout:UICollectionViewFlowLayout = {
                let lay = UICollectionViewFlowLayout()
                lay.scrollDirection = .horizontal
                lay.sectionInset = UIEdgeInsetsMake(10, 20, 0, 20)
                lay.itemSize = CGSize(width: 335, height: 600)
                return lay
            }()
            if topConstraint.constant == -33{
            UIView.animate(withDuration: 0.2, animations: {
                self.topConstraint.constant += -100
                
                self.collectionVW.setCollectionViewLayout(layout, animated: true)
                self.view.layoutIfNeeded()
            })
            }
        }
        else if sender.direction == .down{
            let layout1:UICollectionViewFlowLayout = {
                let lay = UICollectionViewFlowLayout()
                lay.scrollDirection = .horizontal
                lay.sectionInset = UIEdgeInsetsMake(20, 20, 0, 20)
                lay.itemSize = CGSize(width: 335, height: 500)
                return lay
            }()
            UIView.animate(withDuration: 0.2, animations: {
                self.topConstraint.constant = -33
                self.collectionVW.setCollectionViewLayout(layout1, animated: true)
                
                self.view.layoutIfNeeded()
            })

        }
        
    }
    func load(){
        userCategories = []
        for ca in (realm?.objects(Categories.self))!{
            userCategories = ca.category        }
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
                    self.updateDATA(json: jsonVal)
                    
                }
            })
        }
    }
    func updateDATA(json:JSON){
        for i in 0..<10 {
        let title = json["articles"][i]["title"].stringValue
        let data = json["articles"][i]["description"].stringValue
        let imgurl = json["articles"][i]["urlToImage"].url
        let nwurl = json["articles"][i]["url"].url
        let source = json["articles"][i]["source"]["name"].stringValue
            guard let imgURLS = imgurl else{return}
            let nwfeed = NewsFeed(title: title, data: data, imgURL: imgURLS, nwURL: nwurl!, source: source)
        self.newsFeed.append(nwfeed)
        collectionVW.reloadData()
        }
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
    @IBAction func profileButton(_ sender: UIButton) {
        performSegue(withIdentifier: "goToProfile", sender: nil)
    }
    //MARK:Collection view methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsFeed.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NewsFeedCollectionViewCell
        cell.imageVw.sd_setImage(with:newsFeed[indexPath.item].imgURL, completed: nil)
        cell.title.text = newsFeed[indexPath.item].title
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       url2 = newsFeed[indexPath.item].nwURL
       let myWebView = self.storyboard?.instantiateViewController(withIdentifier: "webControl") as? WebViewController
        myWebView?.url = url2
        self.present(myWebView!, animated: true, completion: nil)
        
    }
    
    //MARK:Segue functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ProfileViewController{
            destinationVC.userUID = self.userUID
            print("hi")
        }
}
}

