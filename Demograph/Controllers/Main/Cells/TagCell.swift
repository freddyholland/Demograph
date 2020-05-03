//
//  TagCell.swift
//  Demograph
//
//  Created by iMac on 29/4/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import UIKit

class TagCell: UITableViewCell {
    
    @IBOutlet weak var tagNameField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
