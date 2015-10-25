//
//  TableViewCell.swift
//  Happening
//
//  Created by Prasanthi Relangi on 10/24/15.
//  Copyright © 2015 TeamAwesomeHackingEDU. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var interestsLabel: UILabel!
    
    @IBOutlet weak var iconView: UIImageView!
    var checked = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
