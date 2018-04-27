//
//  CategoryController.swift
//  News Now
//
//  Created by Sarvad shetty on 3/20/18.
//  Copyright © 2018 Sarvad shetty. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Magnetic
import RealmSwift
import iProgressHUD

class CategoryController: UIViewController, MagneticDelegate {
    
    //MARK:Variables
    var userUID:String?
    var categories:[String] = []
    var magnetic:Magnetic?
    let exampleColor = UIColor.black
    let obj = Categories()
    let realm = try? Realm()
    

    //MARK:Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        magnetic?.magneticDelegate = self
        magnetic?.allowsMultipleSelection = true
        magnetic?.backgroundColor = .clear
        let iprogressHUD = iProgressHUD()
        iprogressHUD.attachProgress(toView: self.view)
        iprogressHUD.indicatorStyle = .ballZigZag
        iprogressHUD.iprogressStyle = .horizontal
    }
    override func loadView() {
        super.loadView()
        let magneticView = MagneticView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 450))
        magnetic = magneticView.magnetic
        magneticView.backgroundColor = .clear
        self.view.addSubview(magneticView)
        view.bringSubview(toFront: magneticView)
        
        let tech = Node(text: "Technology", image: UIImage(named:"technology"), color: ColorHelper.shared.colorBlue, radius: 50)
        tech.label.fontColor = ColorHelper.shared.yellowishThing
        magnetic?.addChild(tech)
        let entertainment = Node(text: "Entertainent", image: UIImage(named:"music"), color: ColorHelper.shared.colorBlue, radius: 50)
        entertainment.label.fontColor = ColorHelper.shared.yellowishThing
        magnetic?.addChild(entertainment)
        let sport = Node(text: "Sports", image: UIImage(named:"sports"), color: ColorHelper.shared.colorBlue, radius: 50)
        sport.label.fontColor = ColorHelper.shared.yellowishThing
        magnetic?.addChild(sport)
        let worlds = Node(text: "World", image: UIImage(named:"world"), color: ColorHelper.shared.colorBlue, radius: 50)
        worlds.label.fontColor = ColorHelper.shared.yellowishThing
        magnetic?.addChild(worlds)
        let game = Node(text: "Gaming", image: UIImage(named:"gaming"), color: ColorHelper.shared.colorBlue, radius: 50)
        game.label.fontColor = ColorHelper.shared.yellowishThing
        magnetic?.addChild(game)
        let businesss = Node(text: "Business", image: UIImage(named:"business"), color: ColorHelper.shared.colorBlue, radius: 50)
        businesss.label.fontColor = ColorHelper.shared.yellowishThing
        magnetic?.addChild(businesss)
        let sci = Node(text: "Science", image: UIImage(named:"science"), color: ColorHelper.shared.colorBlue, radius: 50)
        sci.label.fontColor = ColorHelper.shared.yellowishThing
        magnetic?.addChild(sci)
        
        
    }
    
    //MARK:Magnetic function
    func magnetic(_ magnetic: Magnetic, didSelect node: Node) {
        showChild()
    }
    func magnetic(_ magnetic: Magnetic, didDeselect node: Node) {
        showChild()
    }
    
    //MARK:Random functions
    func showChild(){
        guard let num = magnetic?.selectedChildren.count else{return}
        categories = []
        for i in 0..<num{
            categories.append((magnetic?.selectedChildren[i].label.text!)!)
        }
    }
    
    //MARK:IBActions
    @IBAction func doneTapped(_ sender: UIButton) {
        self.view.showProgress()
        let location = Database.database().reference().child("categories").child(userUID!)
        location.setValue(categories)
                obj.category = categories
                do{
                    try realm?.write {
                        realm?.add(obj)
                    }
                }catch{
                }
        self.view.dismissProgress()
        performSegue(withIdentifier: "goToNewsFeed2", sender: nil)
    }
    
    //MARK:Segue functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? NewsFeedController{
            destinationVC.userCategories = categories
            destinationVC.userUID = userUID
        }
    }
    

}
