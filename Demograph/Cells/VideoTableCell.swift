//
//  ExploreTableCell.swift
//  Demograph-Prototype
//
//  Created by Frederick Holland on 29/03/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import UIKit

class VideoTableCell: UITableViewCell {
    
    var controller: ExploreTableView!
    var height: CGFloat = 0
    var link: String!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var videoThumbnail: UIImageView!
    @IBOutlet weak var supportButton: UIButton!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var userPlatformTag: UILabel!
    
    
    var clip: Clip!
    //var clip: Clip = Clip(url: "", title: "", date: "", time: "", platform: Platforms.Email, platformTag: "", id: 0, tags: [], votes: [])
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        height = title.frame.height + videoThumbnail.frame.height + supportButton.frame.height + 16
        
        let touchGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        touchGesture.delegate = self
        videoThumbnail.addGestureRecognizer(touchGesture)
        print("### Recognizer is registered.")
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        print("### Recognized a tap.")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let webView = storyboard.instantiateViewController(withIdentifier: "VideoWebController") as! VideoWebController
        webView.link = link
        controller?.present(webView, animated: true, completion: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func supportButtonPressed(_ sender: Any) {
    }
    @IBAction func moreButtonPressed(_ sender: Any) {
        let profilePage: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "creatorProfile")
        controller?.present(profilePage, animated: true, completion: nil)
    }
}
