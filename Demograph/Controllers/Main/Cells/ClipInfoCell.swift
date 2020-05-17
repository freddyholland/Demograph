//
//  ClipInfoCell.swift
//  Demograph
//
//  Created by iMac on 13/5/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import UIKit

class ClipInfoCell: UITableViewCell {
    
    @IBOutlet weak var platformIconImageView: UIImageView!
    @IBOutlet weak var clipTitleLabel: UILabel!
    @IBOutlet weak var clipInfoLabel: UILabel!
    
    var id: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
