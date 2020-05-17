//
//  AdvertisementCell.swift
//  Demograph
//
//  Created by iMac on 13/5/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import UIKit
import FBAudienceNetwork

class AdvertisementCell: UITableViewCell {
    
    @IBOutlet weak var adUIView: UIView!
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var media: FBMediaView!
    @IBOutlet weak var social_context: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var options: FBAdOptionsView!
    @IBOutlet weak var sponsored: UILabel!
    @IBOutlet weak var body: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionPressed(_ sender: Any) {
    }
    
}
