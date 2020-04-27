//
//  SettingsTableCell.swift
//  Demograph
//
//  Created by Frederick Holland on 26/04/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import UIKit

class SettingsTableCell: UITableViewCell {
    
    @IBOutlet weak var primaryText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
