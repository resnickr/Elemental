//
//  LocationCell.swift
//  1000Museums
//
//  Created by Brian Terry on 2/21/19.
//  Copyright © 2019 RaiderSoft. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var numWorks: UILabel!
    @IBOutlet weak var country: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
