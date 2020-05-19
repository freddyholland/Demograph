//
//  Clip.swift
//  Demograph-Prototype
//
//  Created by Frederick Holland on 01/04/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import Foundation
import FirebaseFirestore

class Clip {
    var url: String
    var title: String
    var publisher: String
    var date: String
    var platform: Platforms
    var platformTag: String
    var id: Int
    var tags: [String]
    var thumbnail: String
    
    init(url:String, title:String, publisher: String, date:String, platform: Platforms, platformTag: String, id: Int, thumbnail: String, tags: [String]) {
        self.url = url
        self.title = title
        self.publisher = publisher
        self.date = date
        self.platform = platform
        self.platformTag = platformTag
        self.id = id
        self.tags = tags
        self.thumbnail = thumbnail
    }
    
    func save() {
        // MARK: - Save the clip to the database under 'ID'
        let id:String = "\(self.id)"
        
        // Get the document reference.
        let doc = Firestore.firestore().collection("clips").document(id)
        
        // Transform the Clip into a dictionary.
        let data: [String:Any] = [
            "id":self.id,
            "title":self.title,
            "publisher": self.publisher,
            "platform":self.platform.rawValue,
            "platform_tag":self.platformTag,
            "thumbnail":self.thumbnail,
            "date":self.date,
            "url":self.url,
            "tags":self.tags
        ]
        
        doc.setData(data)
        
        Firestore.firestore().collection("users").document(self.publisher).getDocument
        { (snapshot, err) in
            if let _ = err {
                print("An error occurred while trying to save a clip to the database.")
                return
            }
            
            var clips: [Int] = snapshot?.get("clips") as! [Int]
            
            if clips.count != 0 {
                clips.append(self.id)
                Firestore.firestore().collection("users").document(self.publisher).setData(["clips":clips], merge: true)
            }
            
        }
    }
    
    public static func getClip(from: [String:Any]) -> Clip {
        let clip = Clip(
            url: from["url"] as! String,
            title: from["title"] as! String,
            publisher: from["publisher"] as! String,
            date: from["date"] as! String,
            platform: Platforms.init(rawValue: from["platform"] as! String)!,
            platformTag: from["platform_tag"] as? String ?? "no tag",
            id: from["id"] as! Int,
            thumbnail: from["thumbnail"] as! String,
            tags:from["tags"] as! [String])
        
        return clip
        
    }
    
    public static func getDictionary(from: Clip) -> [String:Any] {
        var array: [String:Any] = [:]
        array["url"] = from.url
        array["title"] = from.title
        array["publisher"] = from.publisher
        array["date"] = from.date
        array["platform"] = from.platform.rawValue
        array["platformTag"] = from.platformTag
        array["id"] = from.id
        array["thumbnail"] = from.thumbnail
        array["tags"] = from.tags
        
        return array
    }
    
    public static func getClip(from: Int, completion: @escaping (_ clip: Clip) -> Void) {
        // Enter database and retrieve clip from ID.
        // Return this clip.
        // MARK: - Work in progress.
        Firestore.firestore().collection("clips").document("\(from)").getDocument(completion: {
            (snapshot, error) in
            if let error = error {
                return
            }
            
            //let _ = Clip(url: *, title: *, date: *, time: *, platform: *, platformTag: *, id: *, tags: *, votes: -)
            
            if(snapshot?.get("title") != nil) {
                
                let title:String = snapshot?.get("title") as! String
                let publisher:String = snapshot?.get("publisher") as! String
                let url:String = snapshot?.get("url") as! String
                let date:String = snapshot?.get("date") as? String ?? ""
                let thumbnail:String = snapshot?.get("thumbnail") as! String
                let platform_tag:String = snapshot?.get("platform_tag") as? String ?? ""
                let platform:Platforms = Platforms(rawValue: snapshot?.get("platform") as! String)!
                let tags:[String] = snapshot?.get("tags") as! [String]
                
                completion(Clip(url: url, title: title, publisher: publisher, date: date, platform: platform, platformTag: platform_tag, id: from, thumbnail: thumbnail, tags: tags))
                
                /*if snapshot?.get("votes") != nil {
                    let votes = snapshot?.get("votes")
                }*/
            }
        })
    }
    
    /*public static func loadClips(with: Preference, range: Int, completion: @escaping (_ loaded: [Clip]) -> Void)
    {
        with.findRelevantClips(range: range)
        { (clipIDs) in
            var ids: [Int] = []
            for idSet in clipIDs
            {
                let id = idSet.key
                ids.append(id)
            }
            
            loadClips(range: ids)
            { (clips) in
                completion(clips)
            }
        }
    }*/
    
    public static func loadClips(range: Int, completion: @escaping (_ loaded: [Clip]) -> Void)
    {
        
        Firestore.firestore().collection("clips").order(by: "date", descending: true).limit(toLast: range-1).getDocuments
            { (snapshot, error) in
            
                if let error = error
                {
                    
                    
                    completion([])
                } else
                {
                    var loaded: [Clip] = []
                    for clipData in snapshot!.documents {
                        let clip = getClip(from: clipData.data())
                        loaded.append(clip)
                    }
                    
                    completion(loaded)
                }
        }
    }
    
    public static func loadClips(range: [Int], completion: @escaping (_ loaded: [Clip]) -> Void)
    {
        
        var clips: [Clip] = []
        for id in range {
            getClip(from: id, completion:
                { clip in
                
                clips.append(clip)
                if clips.count == range.count {
                    completion(clips)
                }
            })
        }
    }
    
    public static func loadClipsFromSupporting(completion: @escaping (_ loaded: [Clip]) -> Void) {
        
        var clips: [Clip] = []
        Preference.supportingClips(profile: Profile.current) {
            (clipIDs) in
            for clipID in clipIDs
            {
                
                getClip(from: clipID) { (clip) in
                    clips.append(clip)
                    if clips.count == clipIDs.count {
                        // All clips are added to the array.
                        let orderedList = Preference.orderByDate(relevantClips: clips)
                        completion(orderedList)
                    }
                }
                
            }
        }
    }
    
    public static func userPosted(mediaID: String, user: Profile) {
    }
    
    /*public static func loadHotClips(range: Int) -> [Clip] {
        let allClips = loadClips(range: range)
        var unorderedList: [Int:Int] = [:]
        for clip in allClips {
            if unorderedList[clip.id] == nil {
                unorderedList[clip.id] = clip.getScore()
            }
        }
        
        let orderedList = unorderedList.sorted { $1.1 > $0.1 }
        
        var returningClips: [Clip] = []
        for id in orderedList {
            returningClips.append(getClip(from: id.key))
        }
        
        return returningClips
    }*/
    
    /*public static func getMalleableList(forClips: [Clip]) -> [Int:[Tag]] {
        var returningList: [Int:[Tag]] = [:]
        for clip in forClips {
            returningList[clip.id] = clip.tags
        }
        
        return returningList
    }*/
    
    public static func generateID() -> Int
    {
        // Random integer between 0 - 9999999 to use as ID.
        // System will be improved upon upgrading DB.
        let int = Int(arc4random_uniform(9999999))
        return int
    }
    
}
