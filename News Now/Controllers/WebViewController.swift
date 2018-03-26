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
    
    var url:URL?

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.load(URLRequest(url: url!))
    }
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
