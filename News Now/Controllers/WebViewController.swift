//
//  WebViewController.swift
//  News Now
//
//  Created by Sarvad shetty on 3/26/18.
//  Copyright © 2018 Sarvad shetty. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    //MARK:Variables
    var url:URL?

    //MARK:IBOutlets
    @IBOutlet weak var webView: WKWebView!
    
    //MARK:Override functions
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.load(URLRequest(url: url!))
    }
    
    //MARK:IBActions
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
