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
    //var creator: Platform
    var date: String
    var time: String
    var platform: Platforms
    var platformTag: String
    var id: Int
    var tags: [Tag]
    var thumbnail: String
    
    init(url:String, title:String, /*creator:Profile,*/ date:String, time:String, platform: Platforms, platformTag: String, id: Int, thumbnail: String, tags: [Tag]) {
        self.url = url
        self.title = title
        //self.creator = creator
        self.date = date
        self.time = time
        self.platform = platform
        self.platformTag = platformTag
        self.id = id
        self.tags = tags
        self.thumbnail = thumbnail
    }
    
    func save() {
        // MARK: - Save the clip to the database under 'ID'
        let id:String = "\(self.id)"
        let doc = Firestore.firestore().collection("clips").document(id)
        var data: [String:Any] = ["title":self.title, "platform":self.platform.rawValue, "platform_tag":self.platformTag, "thumbnail":self.thumbnail, "time":self.time, "date":self.date,"url":self.url]
        if self.tags.count != 0 {
            var tag_strings: [String] = []
            for tag in self.tags {
                tag_strings.append(tag.name)
            }
            data["tags"] = tag_strings
        } else {
            data["tags"] = []
        }
        
        doc.setData(data)
    }
    
    public static func getClip(from: [String:Any]) -> Clip {
        let clip = Clip(
            url: from["url"] as! String,
            title: from["title"] as! String,
            date: from["date"] as! String,
            time: from["time"] as! String,
            platform: Platforms.init(rawValue: from["platform"] as! String)!,
            platformTag: from["platformTag"] as! String,
            id: from["id"] as! Int,
            thumbnail: from["thumbnail"] as! String,
            tags: [])
        
        let stringTags: [String] = from["tags"] as! [String]
        var tags: [Tag] = []
        for tagString in stringTags {
            tags.append(Tag(name: tagString))
        }
        clip.tags = tags
        
        return clip
        
    }
    
    public static func getDictionary(from: Clip) -> [String:Any] {
        var array: [String:Any] = [:]
        array["url"] = from.url
        array["title"] = from.title
        array["date"] = from.date
        array["time"] = from.time
        array["platform"] = from.platform.rawValue
        array["platformTag"] = from.platformTag
        array["id"] = from.id
        array["thumbnail"] = from.thumbnail
        if from.tags.count != 0 {
            var stringTags: [String] = []
            for tag in from.tags {
                stringTags.append(tag.name)
            }
            array["tags"] = stringTags
        } else {
            array["tags"] = []
        }
        
        return array
    }
    
    public static func getClip(from: Int, completion: @escaping (_ clip: Clip) -> Void) {
        // Enter database and retrieve clip from ID.
        // Return this clip.
        // MARK: - Work in progress.
        Firestore.firestore().collection("clips").document("\(from)").getDocument(completion: {
            (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            
            //let _ = Clip(url: *, title: *, date: *, time: *, platform: *, platformTag: *, id: *, tags: *, votes: -)
            if(snapshot?.get("title") != nil) {
                let title:String = snapshot?.get("title") as! String
                let url:String = snapshot?.get("url") as! String
                let date:String = snapshot?.get("date") as! String
                let time:String = snapshot?.get("time") as! String
                let thumbnail:String = snapshot?.get("thumbnail") as! String
                let platform_tag:String = snapshot?.get("platformTag") as! String
                let platform:Platforms = Platforms(rawValue: snapshot?.get("platform") as! String)!
                var tags:[Tag] = []
                for tagString in snapshot?.get("tags") as! [String] {
                    tags.append(Tag(name: tagString))
                }
                completion(Clip(url: url, title: title, date: date, time: time, platform: platform, platformTag: platform_tag, id: from, thumbnail: thumbnail, tags: tags))
                
                /*if snapshot?.get("votes") != nil {
                    let votes = snapshot?.get("votes")
                }*/
            }
        })
    }
    
    public static func loadClips(range: Int, completion: @escaping (_ loaded: [Clip]) -> Void) {
        
        print("attempting to download clips")
        var clips: [Clip] = []
        for id in 0...range {
            print("downloading \(id)")
            getClip(from: id, completion:
                { clip in
                
                    print("\(id) downloaded")
                    print(clip.url)
                clips.append(clip)
                    print("\(clips.count) / \(range)")
                if clips.count == range {
                    completion(clips)
                }
            })
        }
    }
    
    public static func loadClips(range: [Int], completion: @escaping (_ loaded: [Clip]) -> Void) {
        
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
    
    public static func getMalleableList(forClips: [Clip]) -> [Int:[Tag]] {
        var returningList: [Int:[Tag]] = [:]
        for clip in forClips {
            returningList[clip.id] = clip.tags
        }
        
        return returningList
    }
    
    public static func generateID() -> Int
    {
        // Random integer between 0 - 9999999 to use as ID.
        // System will be improved upon upgrading DB.
        let int = Int(arc4random_uniform(9999999))
        return int
    }
    
    /*public static func identifyClips(with: [Tag]) -> [(key:Int,value:Int)] {
        
        var unorderedList: [Int:Int] = [:]
        let clips = getMalleableList(forClips: loadClips(range: 20))
        for clip in clips {
            let tags = clip.value
            for tag in tags {
                for tag2 in with {
                    if tag.name.lowercased() == tag2.name.lowercased() {
                        if(unorderedList[clip.key] != nil) {
                            let matches = unorderedList[clip.key]
                            unorderedList[clip.key] = matches! + 1
                        } else {
                            unorderedList[clip.key] = 1
                        }
                    }
                }
            }
        }
        
        let orderedList = unorderedList.sorted { $1.1 > $0.1}
        
        return orderedList
    }*/
}
