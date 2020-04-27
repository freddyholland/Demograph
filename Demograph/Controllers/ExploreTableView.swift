//
//  ExploreTableView.swift
//  Demograph-Prototype
//
//  Created by Frederick Holland on 26/03/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import UIKit

class ExploreTableView: UITableViewController {
    
    @IBOutlet weak var newButton: UIButton!
    @IBOutlet weak var hotButton: UIButton!
    @IBOutlet weak var supportingButton: UIButton!
    var selected_button:UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSelectedButton(b: newButton)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // MARK: - Will be replaced in near future.
        return Placeholders.userAccount.clips!.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let clip:Clip = Clip.getClip(from: Placeholders.userAccount.clips![indexPath.row])
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
        let clip: Clip = Clip.getClip(from: Placeholders.userAccount.clips![indexPath.row])
        var identifier = clip.platform.rawValue + "_identifier"
        
        switch clip.platform {
            
        // MARK: - Instagram
        case.Instagram:
            
            identifier = "image_identifier"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ImageTableCell
            cell.height = 205
            cell.clip = clip
            
            // Set the title as the video's title
            cell.firstNameLabel.text = "Posted on Instagram"
            cell.captionLabel.text = clip.title
            
            cell.tagLabel.text = "@" + clip.platformTag
            
            // https://www.instagram.com/p/B-dZbWpA23l/
            // Remove the URL to find the video's ID
            let videoId = clip.url.replacingOccurrences(of: "https://www.instagram.com/p/", with: "").replacingOccurrences(of: "/", with: "")
            // Create the video thumbnail url with the ID
            let videoThumbnailUrlString = "https://www.instagram.com/p/\(videoId)/media/?size=m"
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
    }
    @IBAction func hotButtonPress(_ sender: Any) {
        setSelectedButton(b: hotButton)
    }
    @IBAction func supportingButtonPress(_ sender: Any) {
        setSelectedButton(b: supportingButton)
    }
    
    func setSelectedButton(b: UIButton) {
        selected_button.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1/1)
        selected_button = b
        b.backgroundColor = UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1/1)
    }
}
