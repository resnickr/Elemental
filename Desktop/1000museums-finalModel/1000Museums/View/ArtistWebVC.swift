//
//  LocationWebVC.swift
//  1000Museums
//
//  Created by Brian Terry on 2/25/19.
//  Copyright © 2019 RaiderSoft. All rights reserved.
//

import UIKit
import WebKit
class ArtistWebVC: UIViewController {

    @IBOutlet weak var theWebView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let theURL = TheModel.sharedInstance.artistWork?.buyURL {
            let request = URLRequest(url: URL(string: theURL)!)
            theWebView.load(request)
        }
        // Do any additional setup after loading the view.
    }

}
