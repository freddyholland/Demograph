//
//  PreferenceTagCell.swift
//  Demograph
//
//  Created by iMac on 7/5/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import UIKit

class PreferenceTagCell: UITableViewCell {
    
    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
