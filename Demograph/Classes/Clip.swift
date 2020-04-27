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
    var votes: [Vote]?
    
    init(url:String, title:String, /*creator:Profile,*/ date:String, time:String, platform: Platforms, platformTag: String, id: Int, tags: [Tag], votes: [Vote]) {
        self.url = url
        self.title = title
        //self.creator = creator
        self.date = date
        self.time = time
        self.platform = platform
        self.platformTag = platformTag
        self.id = id
        self.tags = tags
        self.votes = votes
    }
    
    func add(vote:Vote) {
        votes?.append(vote)
    }
    
    func getScore() -> Int {
        if(votes != nil && votes?.count != 0) {
            var score = 0
            for vote in votes! {
                if vote.plus {
                    score += 1
                } else {
                    score -= 1
                }
            }
            
            return score
        } else {
            return 0
        }
    }
    
    func save() {
        // MARK: - Save the clip to the database under 'ID'
        let id:String = "\(self.id)"
        let doc = Firestore.firestore().collection("clips").document(id)
        var data: [String:Any] = ["title":self.title, "platform":self.platform.rawValue, "platform_tag":self.platformTag, "time":self.time, "date":self.date,"url":self.url]
        if self.tags.count != 0 {
            var tag_strings: [String] = []
            for tag in self.tags {
                tag_strings.append(tag.name)
            }
            data["tags"] = tag_strings
        }
        if self.votes?.count != 0 {
            var votes: [[Any]] = []
            for vote in self.votes! {
                votes.append(vote.toDB())
            }
            data["votes"] = votes
        }
        doc.setData(data)
    }
    
    public static func getClip(from: Int, completion: (_ clip: Clip) -> Void) {
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
            }
        })
    }
    
    public static func loadClips(range: Int) -> [Clip] {
        for _ in 0...range {
            // Retrieve most recent list.
            // Access indexes 0 to range in recent list.
            // Return this list.
            // MARK: - Work in progress.
        }
        
        //return Placeholders.userAccount.clips
        return []
    }
    
    public static func loadClips(range: [Int]) -> [Clip] {
        for _ in range {
            // Get clip with ID index.
            // Compile a list of [Clip].
            // Return this list.
            // MARK: - Work in progress.
        }
        
        //return Placeholders.userAccount.clips
        return []
    }
    
    public static func loadHotClips(range: Int) -> [Clip] {
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
    }
    
    public static func getMalleableList(forClips: [Clip]) -> [Int:[Tag]] {
        var returningList: [Int:[Tag]] = [:]
        for clip in forClips {
            returningList[clip.id] = clip.tags
        }
        
        return returningList
    }
    
    public static func identifyClips(with: [Tag]) -> [(key:Int,value:Int)] {
        
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
    }
}
