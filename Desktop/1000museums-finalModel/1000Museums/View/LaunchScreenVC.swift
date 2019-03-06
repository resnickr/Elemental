//
//  LaunchScreenVC.swift
//  1000Museums
//
//  Created by Brian Terry on 2/25/19.
//  Copyright © 2019 RaiderSoft. All rights reserved.
//

import UIKit

class LaunchScreenVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        TheModel.sharedInstance.initProgram { (didComplete) in
            if(didComplete) {
                self.performSegue(withIdentifier: "startProg", sender: self)
            }
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
