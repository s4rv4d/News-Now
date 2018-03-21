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

class CategoryController: UIViewController, MagneticDelegate {
    
    //MARK:Variables
    var userUID:String?
    var categories:[String] = []
    var magnetic:Magnetic?
    let exampleColor = UIColor.black
    

    override func viewDidLoad() {
        super.viewDidLoad()
        magnetic?.magneticDelegate = self
        magnetic?.allowsMultipleSelection = true
        magnetic?.backgroundColor = .clear
       // magnetic.backgroundColor = [UIColor colorWithWhite:myWhiteFloat alpha:myAlphaFloat];
    }

    override func loadView() {
        super.loadView()
        let magneticView = MagneticView(frame: CGRect(x: 0, y: 0, width: 375, height: 450))
        magnetic = magneticView.magnetic
        magneticView.backgroundColor = .clear
        self.view.addSubview(magneticView)
        view.bringSubview(toFront: magneticView)
        
        let node = Node(text: "Italy", image: nil, color: .red, radius: 30)
        magnetic?.addChild(node)
        let node2 = Node(text: "france", image: nil, color: .red, radius: 30)
        magnetic?.addChild(node2)
        let node3 = Node(text: "india", image: nil, color: .red, radius: 30)
        magnetic?.addChild(node3)
        
    }
    
    func magnetic(_ magnetic: Magnetic, didSelect node: Node) {
        showChild()
    }
    
    func magnetic(_ magnetic: Magnetic, didDeselect node: Node) {
        print("bye")
        showChild()
    }
    func showChild(){
        guard let num = magnetic?.selectedChildren.count else{return}
        categories = []
        for i in 0..<num{
            categories.append((magnetic?.selectedChildren[i].label.text!)!)
        }
        print(categories)
    }
    

}
