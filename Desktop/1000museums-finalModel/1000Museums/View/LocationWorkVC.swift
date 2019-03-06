//
//  WorkVCViewController.swift
//  1000Museums
//
//  Created by Brian Terry on 2/18/19.
//  Copyright © 2019 RaiderSoft. All rights reserved.
//

import UIKit

class LocationWorkVC: UIViewController {

    @IBOutlet weak var workImageView: UIImageView!
    @IBOutlet weak var workDescriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mediumLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var purchaseButton: UIButton!
    
    
    
    override func viewDidLoad() {
        
        /*
        if (TheModel.sharedInstance.locationWork?.buyURL! != ""){
            museumWebVC.theURL = TheModel.sharedInstance.locationWork?.buyURL!
        }else {
            museumWebVC.theURL = "https://www.1000museums.com/"
        }
        */
        
        if let work = TheModel.sharedInstance.locationWork{
            self.nameLabel.text = String(format: "%@", work.name ?? "")
            self.mediumLabel.text = String(format: "%@", work.medium ?? "")
            self.yearLabel.text = String(format: "%d", work.year ?? "")
            
            if (work.buyURL == "") {
                purchaseButton.isHidden = true
            }
    
            TheModel.sharedInstance.downloadFullImage(work: work) {_ in
                self.workImageView.image = UIImage(data: work.imageFile as! Data)
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapResponse))
                self.workImageView.addGestureRecognizer(tapGestureRecognizer)
            }
        }

        // Do any additional setup after loading the view.
    }
    @objc func tapResponse() {
        performSegue(withIdentifier: "fullScreen1", sender: self)
    }
    


    @IBAction func buyButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toWebView", sender: self)
    }
    
}
