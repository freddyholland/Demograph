//
//  ExploreTableView.swift
//  Demograph-Prototype
//
//  Created by Frederick Holland on 26/03/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import UIKit
import EzPopup
import GoogleMobileAds
import FBAudienceNetwork
import AdSupport

class ExploreTableView: UITableViewController, GADUnifiedNativeAdDelegate {
    
    @IBOutlet weak var newButton: UIButton!
    @IBOutlet weak var hotButton: UIButton!
    @IBOutlet weak var supportingButton: UIButton!
    var selected_button:UIButton = UIButton()
    
    //var clipsToLoad = [1]
    var loadedClips: [Clip] = []
    
    var newClips: [Clip] = []
    var hotClips: [Clip] = []
    var supportingClips: [Clip] = []
    
    var loaded: Bool = false
    
    private let tableRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.refreshControl = tableRefreshControl
        tableRefreshControl.addTarget(self, action: #selector(self.reloadExploreInput), for: .valueChanged)
        
        setSelectedButton(b: newButton)
        
        setupFBAd()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 500
        
        if (Profile.current.id.isEmpty)
        {
            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true)
            { (timer) in
                
                if !Profile.current.local_tag.isEmpty
                {
                    
                    self.loadCategories()
                    self.loaded = true
                    timer.invalidate()
                }
                
            }
        } else {
            loaded = true
            loadCategories()
        }
        
        
    }
    
    @objc func reloadExploreInput() {
        loadCategories()
    }
    
    func loadCategories() {
        
        let ad = Clip(url: "", title: "This is an ad!", publisher: "", date: "", platform: Platforms.Advertisement, platformTag: "", id: 0, thumbnail: "", tags: [])
        
        loaded = false
        var count: Int = 0
        
        Clip.loadClips(range: 8)
        { (clips) in
            self.newClips = Preference.orderByDate(relevantClips: clips)
            self.newClips.append(ad)
            self.loadedClips = self.newClips
            self.tableView.reloadData()
            
            count += 1
            if count == 3 {
                self.loaded = true
            }
        }
        
        Placeholders.temporary_preference.findRelevantClips(range: 8)
        { (clips) in
            self.hotClips = clips
            self.hotClips.append(ad)
            
            count += 1
            if count == 3 {
                self.loaded = true
            }
        }
        
        Clip.loadClipsFromSupporting
        { (clips) in
            
            self.supportingClips = clips
            self.supportingClips.append(ad)
            
            count += 1
            if count == 3 {
                self.loaded = true
            }
        }
        
        
        
        self.tableRefreshControl.endRefreshing()
    }
    
    func loadMore(category: Int) {
        switch category {
            // Case 0 = New Clips
        case 0:
            Clip.loadClips(range: 8)
            { (clips) in
                self.newClips.append(contentsOf: clips)
                self.tableView.reloadData()
            }
            
            // Case 1 = Hot Clips
        case 1:
            Placeholders.temporary_preference.findRelevantClips(range: 8)
            { (clips) in
                self.hotClips.append(contentsOf: clips)
                self.tableView.reloadData()
            }
            
            // Case 2 = Supporting Clips
        case 2:
            Clip.loadClipsFromSupporting
            { (clips) in
                self.supportingClips.append(contentsOf: clips)
                self.tableView.reloadData()
            }
        default:
            return
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    // MARK: - Number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // MARK: - Will be replaced in near future.
        
        return loadedClips.count + 1
    }
    
    // MARK: - Row height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 43
        } else {
        
            let clip:Clip = loadedClips[indexPath.row - 1]
            
            switch clip.platform {
            case .Advertisement:
                return 291
            case .Instagram:
                return 205
            case .Soundcloud, .Spotify:
                return 161
            case .Twitch, .Youtube:
                return 300
            default:
                return 45
            }
        }
        
    }
    
    /*override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 43
        } else {
        
            let clip:Clip = loadedClips[indexPath.row - 1]
            
            switch clip.platform {
            case .Advertisement:
                return 291
            case .Instagram:
                return 205
            case .Soundcloud, .Spotify:
                return 161
            case .Twitch, .Youtube:
                return 280
            default:
                return 45
            }
        }
    }*/
    
    // MARK: - Configure the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "preferenceIdentifier", for: indexPath)
            return cell
            
        } else {
            
            // Configure the cell...
            let clip: Clip = loadedClips[indexPath.row-1]
            var identifier = clip.platform.rawValue + "_identifier"
            
            switch clip.platform {
                
            // MARK: - Instagram
            case.Instagram:
                
                identifier = "image_identifier"
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ImageTableCell
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
                
                cell.title.text = clip.title
                cell.firstNameLabel.text = "Posted on Soundcloud"
                cell.tagLabel.text = clip.platformTag
                
                return cell
                
            // MARK: - Twitch
            case.Twitch:
                
                identifier = "video_identifier"
                
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! VideoTableCell
                cell.clip = clip
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
                
                cell.title.text = clip.title
                cell.firstNameLabel.text = "Posted on Spotify"
                cell.tagLabel.text = clip.platformTag
                
                return cell
                
            // MARK: - Youtube
            case.Youtube:
                
                identifier = "video_identifier"
                
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! VideoTableCell
                cell.clip = clip
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
            
            
                case.Advertisement:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "advertisementIdentifier", for: indexPath) as! AdvertisementCell
                    adViews.append(cell)
                    
                    // v This needs to be called in viewDidLoad
                    //adLoader.load(GADRequest())
                    nativeAd.loadAd()
                    
                    return cell
                
                default:
                    let cell = tableView.dequeueReusableCell(withIdentifier: identifier)! as UITableViewCell
                    return cell
            }
            
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
    
    // MARK: - Native Ad Manager (AdMob)
    /*
    func setupAdLoader() {
        adLoader = GADAdLoader(adUnitID: adUnitID, rootViewController: self, adTypes: [.unifiedNative], options: nil)
        adLoader.delegate = self
    }
    
    var adLoader: GADAdLoader!
    var adUnitID = "ca-app-pub-3940256099942544/3986624511"
    
    */
    
    // MARK: - Native Ad Manager (FAN)
    
    var adViews: [AdvertisementCell] = []
    
    func setupFBAd() {
        nativeAd = FBNativeAd(placementID: "379241669659253_379242252992528")
        nativeAd.delegate = self;
    }
    
    var nativeAd: FBNativeAd!
}

extension ExploreTableView: FBNativeAdDelegate {
    func nativeAdDidLoad(_ nativeAd: FBNativeAd) {
        self.nativeAd = nativeAd
        
        let cell = adViews.last!
        
        nativeAd.registerView(forInteraction: cell.adUIView, mediaView: cell.media, iconImageView: cell.icon, viewController: self, clickableViews: [ cell.media, cell.button ])
        
        if let advertiser = nativeAd.advertiserName {
            cell.sponsored.text = advertiser
        }
        
        if let body = nativeAd.bodyText {
            cell.body.text = body
        }
        
        if let socialContext = nativeAd.socialContext {
            cell.social_context.text = socialContext
        }
        
        if let callToAction = nativeAd.callToAction {
            cell.button.setTitle(callToAction, for: .normal)
        }
        
    }
}

/*extension ExploreTableView: GADVideoControllerDelegate {
    func videoControllerDidEndVideoPlayback(_ videoController: GADVideoController) {
        "Video playback ended")
    }
}

extension ExploreTableView: GADUnifiedNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        "No ad could be loaded")
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        
        "loading an ad")
        "\(adViews) <- rows that are configured as ads. check if row \(adViews.last!) is an AdvertisementCell")
        let cell = adViews.last!
        nativeAd.delegate = self
        
        let mediaContent = nativeAd.mediaContent
        
        "ad loaded with headline \(nativeAd.headline!)")
        cell.advertisementText.text = nativeAd.headline!
        cell.nativeAdViewPlaceholder!.mediaContent = mediaContent
        if let advertiser = nativeAd.advertiser {
            cell.secondaryInfo.text = "from: \(advertiser)"
        }
        if let callToAction = nativeAd.callToAction {
            cell.actionButton.titleLabel?.text = callToAction
        }
        /*if mediaContent.hasVideoContent {
            mediaContent.videoController.delegate = self
        } else {
            
        }*/
        //cell.nativeAdViewPlaceholder = nativeAd.mediaContent.mainImage
    }
}*/
