//
//  PlatformTableCell.swift
//  Demograph-Prototype
//
//  Created by Frederick Holland on 31/03/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import UIKit

class PlatformTableCell: UITableViewCell {
    
    @IBOutlet weak var platformIcon: UIImageView!
    @IBOutlet weak var userFullname: UILabel!
    @IBOutlet weak var userLink: UILabel!
    @IBOutlet weak var userInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
