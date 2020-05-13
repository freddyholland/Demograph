//
//  ImageTableCell.swift
//  Demograph-Prototype
//
//  Created by Frederick Holland on 04/04/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import UIKit

class ImageTableCell: UITableViewCell {
    
    
    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var supportButton: UIButton!
    
    
    var controller: ExploreTableView!
    var height: CGFloat = 0
    var link: String!
    var clip: Clip = Placeholders.emptyClip
    var supporting: Bool!
    var allowsInteraction: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.height = 205
        
        let touchGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        touchGesture.delegate = self
        displayImageView.addGestureRecognizer(touchGesture)
        
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
        print("Image interacted with and allowsInteraction = \(allowsInteraction)")
        if allowsInteraction
        {
            print("Attempting to open weblink.")
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
    
    @IBAction func moreButtonPress(_ sender: Any) {
        
        if !allowsInteraction
        {
            return
        }
        
        let profilePage: CreatorProfileTableView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "creatorProfile") as! CreatorProfileTableView
        profilePage.userID = clip.publisher
        controller?.present(profilePage, animated: true, completion: nil)
        
    }
    
    @IBAction func supportButtonPress(_ sender: Any) {
        
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
                    supportButton.titleLabel?.text = "Support"
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
            supportButton.titleLabel?.text = ":)"
        }
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
            supportButton.backgroundColor = Placeholders.green
        } else
        {
            // Currently supporting.
            print("Currently supporting")
            self.supporting = true
            supportButton.backgroundColor = Placeholders.dark_green
        }
        
        self.allowsInteraction = true
    }
    
}
