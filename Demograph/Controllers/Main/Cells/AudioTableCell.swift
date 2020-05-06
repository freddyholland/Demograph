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
    @IBOutlet weak var supportButton: UIButton!
    
    
    var clip: Clip!
    
    var controller: ExploreTableView!
    var height: CGFloat = 0
    var link: String!
    var supporting: Bool!
    var allowsInteraction: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //sself.height = 161
        
        if (clip.publisher.isEmpty) || (Profile.current.id.isEmpty)
        {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true)
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func moreButtonPress(_ sender: Any) {
    }
    
    @IBAction func supportButtonPress(_ sender: Any) {
        if supporting {
            // Stop supporting.
            var supporting = Profile.current.supporting!
            for index in 0...supporting.count {
                if supporting[index] == clip.publisher
                {
                    supporting.remove(at: index)
                    
                    Profile.current.supporting = supporting
                    Profile.attemptSaveCurrent
                        { (success) in
                            if !success
                            {
                                print("An error occurred when removing a user from supporting array.")
                                return
                            }
                    }
                }
            }
        } else
        {
            // Support.
            Profile.current.supporting?.append(clip.publisher)
            Profile.attemptSaveCurrent
                { (success) in
                    if !success
                    {
                        print("An error occurred when updating users.")
                        return
                    }
            }
        }
    }
    
    @IBAction func playButtonPress(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let webView = storyboard.instantiateViewController(withIdentifier: "VideoWebController") as! VideoWebController
        webView.link = clip.url
        controller?.present(webView, animated: true, completion: nil)
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
