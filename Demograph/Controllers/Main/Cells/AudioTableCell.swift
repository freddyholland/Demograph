//
//  AudioTableCell.swift
//  Demograph-Prototype
//
//  Created by Frederick Holland on 04/04/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import UIKit

class AudioTableCell: UITableViewCell {
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    
    
    var clip: Clip = Clip(url: "", title: "", date: "", time: "", platform: Platforms.Email, platformTag: "", id: 0, thumbnail: "", tags: [])
    
    var controller: ExploreTableView!
    var height: CGFloat = 0
    var link: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.height = 161
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func moreButtonPress(_ sender: Any) {
    }
    
    @IBAction func supportButtonPress(_ sender: Any) {
    }
    
    @IBAction func playButtonPress(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let webView = storyboard.instantiateViewController(withIdentifier: "VideoWebController") as! VideoWebController
        webView.link = link
        controller?.present(webView, animated: true, completion: nil)
    }
    
}
