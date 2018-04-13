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
import iProgressHUD

class NewsFeedController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK:Variables
    var userCategories:[String] = []
    var userUID:String!
    var newsFeed:[NewsFeed] = []
    var parameters:[String:String]!
    let url = newsURL()
    let obj = Categories()
    let prof = Profile()
    let realm = try? Realm()
    var cat : [String] = []
    var url2:URL?
    var flag = 0
    var reachability:Reachability!
    var counter = 0
    var locationCol:Float = 1.0
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    
    //MARK:IBOutlets
    @IBOutlet weak var collectionVW: UICollectionView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet var master: UIView!
    @IBOutlet weak var bottomConstarin: NSLayoutConstraint!
    @IBOutlet weak var topConstarint: NSLayoutConstraint!
    @IBOutlet weak var topBarView: UIView!
    
    //MARK:Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reachability = Reachability.init()
        load()
        getCat()
        getData()
        let iprogressHUD = iProgressHUD()
        iprogressHUD.attachProgress(toView: self.view)
        iprogressHUD.indicatorStyle = .ballZigZag
        iprogressHUD.iprogressStyle = .horizontal
        if flag == 0{
            self.view.showProgress()
            flag = 1
        }
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(NewsFeedController.handleSwipe(_:)))
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(NewsFeedController.handleSwipe(_:)))
        upSwipe.direction = .up
        downSwipe.direction = .down
        view.addGestureRecognizer(upSwipe)
        view.addGestureRecognizer(downSwipe)
        collectionVW.decelerationRate = 0.2
        persistProfileData()
        updateTopBarView()
    }
    override func viewDidAppear(_ animated: Bool) {
        checkConnection()
    }
    
    //MARK:Random functions
    @objc func handleSwipe(_ sender:UISwipeGestureRecognizer){
        if sender.direction == .up{
            let layout:UICollectionViewFlowLayout = {
                let lay = UICollectionViewFlowLayout()
                lay.scrollDirection = .horizontal
                lay.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
                lay.itemSize = CGSize(width: self.view.frame.width , height: self.view.frame.height)
                return lay
            }()
            if topConstraint.constant == -33{
                self.bottomConstarin.constant = 0
                self.topConstarint.constant = 0
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
                lay.sectionInset = UIEdgeInsetsMake(20, 20, 10, 20)
                lay.itemSize = CGSize(width: self.view.frame.width * 0.8, height: self.view.frame.height - 167)
                return lay
            }()
            self.bottomConstarin.constant = 49
            self.topConstarint.constant = 73
            UIView.animate(withDuration: 0.2, animations: {
                self.topConstraint.constant = -33
                self.collectionVW.setCollectionViewLayout(layout1, animated: true)
                self.view.layoutIfNeeded()
            })

        }
        
    }
    func load(){
        userCategories = []
        self.view.showProgress()
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
    func persistProfileData(){
                Database.database().reference().child("users").child(userUID!).observe(.value) { (dataSnapshot) in
                    if let snapshot = dataSnapshot.children.allObjects as?[DataSnapshot]{
                        guard let userNm = snapshot[1].value, let imURL = snapshot[0].value else {return}
                        
                        let ref = Storage.storage().reference(forURL: imURL as! String)
                        
                        ref.getData(maxSize: 1000000000, completion: { (data, error) in
                            if error != nil{
                                print("couldnt download image")
                            }else{
                                guard let imageData = data else{return}
                                do{
                                    try self.realm?.write {
                                        let prof1 = Profile()
                                        prof1.user = userNm as! String
                                        prof1.imageURL = imageData
                                        self.realm?.add(prof1)
                                    }
                                }catch{}
                            }
                            })}
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
                self.view.dismissProgress()
                let queue = DispatchQueue(label: "lol", qos: DispatchQoS.background)
                queue.sync {
                      self.collectionVW.reloadData()
                }
               
        }
    }
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
    func updateTopBarView(){
        gradientSet.append([ColorHelper.shared.colorBlue.cgColor, ColorHelper.shared.yellowishThing.cgColor])
        gradientSet.append([ColorHelper.shared.yellowishThing.cgColor, ColorHelper.shared.colorBlue.cgColor])
        gradientSet.append([ColorHelper.shared.colorBlue.cgColor, ColorHelper.shared.colorBlue.cgColor])
        gradientSet.append([ColorHelper.shared.colorBlue.cgColor, ColorHelper.shared.yellowishThing.cgColor])
        gradient.frame = CGRect(x: 0, y: 0, width: topBarView.frame.width, height: topBarView.frame.height)
        gradient.colors = gradientSet[currentGradient]
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        gradient.drawsAsynchronously = true
        topBarView.layer.insertSublayer(gradient, at: 0)
        animateGradient()
    }
    func animateGradient() {
        if currentGradient < gradientSet.count {
            currentGradient += 1
        } else {
            currentGradient = 0
        }
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 5.0
        gradientChangeAnimation.toValue = gradientSet[currentGradient]
        gradientChangeAnimation.fillMode = kCAFillModeForwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradient.add(gradientChangeAnimation, forKey: "colorChange")
    }
    
    //MARK:IBActions
    @IBAction func signOut(_ sender: UIButton) {
        self.view.showProgress()
        do{
            try Auth.auth().signOut()
            KeychainWrapper.standard.removeObject(forKey: "uid")
            for ca in (realm?.objects(Categories.self))!{
                do{
                    try realm?.write {
                        realm?.delete(ca)
                    }
                }catch{}
            }
            for pf in (realm?.objects(Profile.self))!{
                do{
                    try realm?.write {
                        realm?.delete(pf)
                    }
                }catch{}
            }
            self.view.dismissProgress()
            dismiss(animated: true, completion: nil)
            flag = 0
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
            cell.imageVw.sd_setImage(with:self.newsFeed[indexPath.item].imgURL, completed: nil)
            cell.title.text = newsFeed[indexPath.item].title
            cell.company.text = newsFeed[indexPath.item].source
            cell.contentView.layer.cornerRadius = 14
            cell.contentView.layer.masksToBounds = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.showProgress()
       url2 = newsFeed[indexPath.item].nwURL
       let myWebView = self.storyboard?.instantiateViewController(withIdentifier: "webControl") as? WebViewController
        myWebView?.url = url2
        self.view.dismissProgress()
        self.present(myWebView!, animated: true, completion: nil)
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        // Do whatever with currentPage.
//        counter = currentPage
//        let diff:Float = 0.2
//        let locationSome = Float(Float(Float(currentPage) * diff) + locationCol)
//        if counter == 10{
//            counter = 0
//            print(locationSome)
//        }
//        let NSNumberVal = NSNumber(value: locationSome)
//        print(NSNumberVal)
//        UIView.animate(withDuration: 1.0) {
//            self.topBarView.setGradientBackgroundWithLocation(colorOne: ColorHelper.shared.colorBlue, colorTwo: ColorHelper.shared.yellowishThing, locationTwo: NSNumberVal)
//            self.view.layoutIfNeeded()
//        }
        updateTopBarView()


    }
    
    
    //MARK:Segue functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ProfileViewController{
            destinationVC.userUID = self.userUID
        }
}
}
extension NewsFeedController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
    
}




