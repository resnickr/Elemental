//
//  FullScreenVCViewController.swift
//  1000Museums
//
//  Created by Brian Terry on 2/23/19.
//  Copyright © 2019 RaiderSoft. All rights reserved.
//

import UIKit

class LocationFullScreenVC: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var theScrollView: UIScrollView!
    @IBOutlet weak var theImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let myImage = UIImage(data: TheModel.sharedInstance.locationWork?.imageFile! as! Data) {
            theImageView.image = myImage
        }
        self.theScrollView.minimumZoomScale = 1.0
        self.theScrollView.maximumZoomScale = 6.0
        
        // Do any additional setup after loading the view.
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.theImageView
    }
    
}
