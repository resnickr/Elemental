//
//  MuseumWebVCViewController.swift
//  1000Museums
//
//  Created by Brian Terry on 2/25/19.
//  Copyright © 2019 RaiderSoft. All rights reserved.
//

import UIKit
import WebKit
class LocationWebVC: UIViewController {
    
    @IBOutlet weak var theWebView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let theURL = TheModel.sharedInstance.locationWork?.buyURL {
            let request = URLRequest(url: URL(string: theURL)!)
            theWebView.load(request)
        }
        // Do any additional setup after loading the view.
    }
    

}
