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
    var supporting: Bool!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var videoThumbnail: UIImageView!
    @IBOutlet weak var supportButton: UIButton!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var userPlatformTag: UILabel!
    
    
    var clip: Clip = Placeholders.emptyClip
    var allowsInteraction: Bool = false
    //var clip: Clip = Clip(url: "", title: "", date: "", time: "", platform: Platforms.Email, platformTag: "", id: 0, tags: [], votes: [])
    
    /*override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            Account.getProfile(userID: clip.publisher)
            { (publisher) in
                if !(Profile.current.supporting?.contains(publisher.id))!
                {
                    // Not currently supporting.
                    print("Not currently supporting")
                    self.supporting = false
                } else
                {
                    // Currently supporting.
                    print("Currently supporting")
                    self.supporting = true
                }
            }
        }
    }*/
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //height = title.frame.height + videoThumbnail.frame.height + supportButton.frame.height + 16
        
        let touchGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        touchGesture.delegate = self
        videoThumbnail.addGestureRecognizer(touchGesture)
        
        if (clip.publisher.isEmpty) || (Profile.current.id.isEmpty)
        {
            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true)
            { (timer) in
                
                if !self.clip.publisher.isEmpty && !Profile.current.local_tag.isEmpty
                {
                    self.loadSupportingValue()
                    
                    timer.invalidate()
                }
                
                
            }
        } else {
            
            print("calling too early in the else statement")
            loadSupportingValue()
            
        }
        
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        
        if allowsInteraction
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let webView = storyboard.instantiateViewController(withIdentifier: "VideoWebController") as! VideoWebController
            webView.link = clip.url
            controller?.present(webView, animated: true, completion: nil)
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func supportButtonPressed(_ sender: Any) {
        
        print("allowsInteraction = \(allowsInteraction)")
        
        if !allowsInteraction
        {
            return
        }
        
        print("supporting = \(supporting!)")
        
        if supporting {
            // Stop supporting.
            var supporting = Profile.current.supporting!
            for index in 0...supporting.count-1 {
                if supporting[index] == clip.publisher
                {
                    supporting.remove(at: index)
                    
                    Profile.current.supporting = supporting
                    Account.updateSupporting(profile: Profile.current)
                    self.supporting = false
                    supportButton.backgroundColor = Placeholders.green
                    supportButton.titleLabel?.text = "v/"
                }
            }
            
        } else
        {
            // Support.
            Profile.current.supporting!.append(clip.publisher)
            print(Profile.current.supporting!)
            Account.updateSupporting(profile: Profile.current)
            self.supporting = true
            supportButton.backgroundColor = Placeholders.dark_green
            supportButton.titleLabel?.text = "v/"
        }
    }
    @IBAction func moreButtonPressed(_ sender: Any) {
        
        if !allowsInteraction
        {
            return
        }
        
        let profilePage: CreatorProfileTableView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "creatorProfile") as! CreatorProfileTableView
        profilePage.userID = clip.publisher
        controller?.present(profilePage, animated: true, completion: nil)
    }
    
    func loadSupportingValue() {
        print("Attempting to load supporting value.")
            
        print("Creator ID = \(self.clip.publisher)")
        print("User supporting list = \(Profile.current.supporting!)")
        print(Profile.current.id + " " + Profile.current.local_tag)
        
        if !(Profile.current.supporting!.contains(self.clip.publisher))
        {
            // Not currently supporting.
            print("Not currently supporting")
            self.supporting = false
        } else
        {
            // Currently supporting.
            print("Currently supporting")
            self.supporting = true
        }
        
        self.allowsInteraction = true
    }
}
