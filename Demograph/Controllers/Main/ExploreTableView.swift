//
//  ExploreTableView.swift
//  Demograph-Prototype
//
//  Created by Frederick Holland on 26/03/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import UIKit
import EzPopup

class ExploreTableView: UITableViewController {
    
    @IBOutlet weak var newButton: UIButton!
    @IBOutlet weak var hotButton: UIButton!
    @IBOutlet weak var supportingButton: UIButton!
    var selected_button:UIButton = UIButton()
    
    //var clipsToLoad = [1]
    var loadedClips: [Clip] = []
    
    var newClips: [Clip] = []
    var hotClips: [Clip] = []
    var supportingClips: [Clip] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSelectedButton(b: newButton)
        print("loading clips")
        
        if (Profile.current.id.isEmpty)
        {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true)
            { (timer) in
                
                if !Profile.current.local_tag.isEmpty
                {
                    let alert = AlertViewController.instantiate()
                    alert.titleString = "Custom Controller!"
                    alert.messageString = "Successfully loaded a custom Alert View Controller."
                    alert.view.backgroundColor = UIColor.white
                    
                    let popupVC = PopupViewController(contentController: alert, popupWidth: 300, popupHeight: 200)
                    popupVC.backgroundAlpha = 1
                    popupVC.backgroundColor = UIColor.white
                    popupVC.canTapOutsideToDismiss = true
                    popupVC.shadowEnabled = false
                    
                    self.present(popupVC, animated: true, completion: nil)
                    
                    self.loadCategories()
                    timer.invalidate()
                }
                
                
            }
        } else {
            loadCategories()
        }
        
        
    }
    
    func loadCategories() {
        
        /*Clip.loadClips(range: 10)
        { (loaded) in
            for newClip in loaded {
                self.newClips.append(newClip)
            }
            
            print("loaded in 'new' data")
            self.loadedClips = self.newClips
            self.tableView.reloadData()
        }*/
        
        /*Clip.loadClips(with: Placeholders.temporary_preference, range: 10)
        { (loaded) in
            for newClip in loaded {
                self.newClips.append(newClip)
            }
            
            print("loaded in 'new' data")
            self.loadedClips = self.newClips
            self.tableView.reloadData()
        }*/
        
        Clip.loadClips(range: 10)
        { (clips) in
            print("Loaded new recent clips.")
            self.newClips = Preference.orderByDate(relevantClips: clips)
            self.loadedClips = self.newClips
            self.tableView.reloadData()
        }
        
        Placeholders.temporary_preference.findRelevantClips(range: 10)
        { (clips) in
            print("Loaded new clips with Preference.")
            self.hotClips = clips
        }
        
        Clip.loadClipsFromSupporting
        { (clips) in
            print("Loaded supporting clips.")
            self.supportingClips = clips
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // MARK: - Will be replaced in near future.
        return loadedClips.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let clip:Clip = loadedClips[indexPath.row]
        
        switch clip.platform {
        case .Instagram:
            return 205
        case .Soundcloud, .Spotify:
            return 161
        case .Twitch, .Youtube:
            return 295
        default:
            return 45
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Attempting to setup cell @ \(indexPath.row)")
        
        // Configure the cell...
        let clip: Clip = loadedClips[indexPath.row]
        print("The publisher ID is: " + clip.publisher)
        print("Loaded for the clip with ID: \(clip.id)")
        var identifier = clip.platform.rawValue + "_identifier"
        
        switch clip.platform {
            
        // MARK: - Instagram
        case.Instagram:
            
            identifier = "image_identifier"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ImageTableCell
            cell.height = 205
            cell.clip = clip
            cell.controller = self
            
            // Set the title as the video's title
            cell.firstNameLabel.text = "Posted on Instagram"
            cell.captionLabel.text = clip.title
            
            cell.tagLabel.text = "@" + clip.platformTag
            
            // Create the video thumbnail url with the ID
            let videoThumbnailUrlString = clip.thumbnail
            // Create URL from string
            let videoThumbnailUrl = URL(string: videoThumbnailUrlString)
            
            // Check the URL isn't empty
            if videoThumbnailUrl != nil {
                
                // Create request from URL
                let request = URLRequest(url: videoThumbnailUrl!)
                let session = URLSession.shared
                
                // Extract data
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: {
                    (data:Data?, response:URLResponse?, error:Error?) in
                    
                    DispatchQueue.main.async {
                        
                        // Find cell's imageView and set the image to the retrieved data.
                        cell.displayImageView.image = UIImage(data: data!)
                    }
                })
                dataTask.resume()
                
            }
            
            return cell
            
        // MARK: - Soundcloud
        case.Soundcloud:
            
            identifier = "audio_identifier"
            
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! AudioTableCell
            cell.clip = clip
            cell.height = 161
            
            cell.title.text = clip.title
            cell.firstNameLabel.text = "Posted on Soundcloud"
            cell.tagLabel.text = clip.platformTag
            
            return cell
            
        // MARK: - Twitch
        case.Twitch:
            
            identifier = "video_identifier"
            
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! VideoTableCell
            cell.clip = clip
            cell.height = 300
            cell.link = clip.url
            cell.controller = self
            
            cell.title.text = clip.title
            cell.subtitle.text = "Posted on Twitch"
            cell.userPlatformTag.text = clip.platformTag
            
            return cell
            
        // MARK: - Spotify
        case.Spotify:
            
            identifier = "audio_identifier"
            
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! AudioTableCell
            cell.clip = clip
            cell.height = 161
            
            cell.title.text = clip.title
            cell.firstNameLabel.text = "Posted on Spotify"
            cell.tagLabel.text = clip.platformTag
            
            return cell
            
        // MARK: - Youtube
        case.Youtube:
            
            identifier = "video_identifier"
            
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! VideoTableCell
            print("In ETV clip publisher equals \(clip.publisher)")
            cell.clip = clip
            cell.height = 300
            cell.link = clip.url
            cell.controller = self
            
            // Set the title as the video's title
            cell.subtitle.text = "Posted on Youtube"
            cell.title.text = clip.title
            
            cell.userPlatformTag.text = clip.platformTag
            
            // Remove the URL to find the video's ID
            let videoId = clip.url.replacingOccurrences(of: "https://www.youtube.com/watch?v=", with: "")
            // Create the video thumbnail url with the ID
            let videoThumbnailUrlString = "https://i1.ytimg.com/vi/" + videoId + "/mqdefault.jpg"
            // Create URL from string
            let videoThumbnailUrl = URL(string: videoThumbnailUrlString)
            
            // Check the URL isn't empty
            if videoThumbnailUrl != nil {
                
                // Create request from URL
                let request = URLRequest(url: videoThumbnailUrl!)
                let session = URLSession.shared
                
                // Extract data
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: {
                    (data:Data?, response:URLResponse?, error:Error?) in
                    
                    DispatchQueue.main.async {
                        
                        // Find cell's imageView and set the image to the retrieved data.
                        let imageView = cell.videoThumbnail
                        imageView?.image = UIImage(data: data!)
                    }
                })
                dataTask.resume()
            }
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)! as UITableViewCell
            print("There was an explore cell that didnt have a valid platform")
            return cell
        }
    }
    
    @IBAction func newButtonPress(_ sender: Any) {
        setSelectedButton(b: newButton)
        
        loadedClips = newClips
        tableView.reloadData()
    }
    @IBAction func hotButtonPress(_ sender: Any) {
        setSelectedButton(b: hotButton)
        
        loadedClips = hotClips
        tableView.reloadData()
    }
    @IBAction func supportingButtonPress(_ sender: Any) {
        setSelectedButton(b: supportingButton)
        
        loadedClips = supportingClips
        tableView.reloadData()
    }
    
    func setSelectedButton(b: UIButton) {
        selected_button.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1/1)
        selected_button = b
        b.backgroundColor = UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1/1)
    }
}
