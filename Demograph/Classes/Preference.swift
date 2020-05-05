//
//  Preference.swift
//  Demograph
//
//  Created by iMac on 3/5/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import Foundation

class Preference {
    var types: [Platforms]
    var tags: [Tag]
    
    init(types: [Platforms], tags: [Tag])
    {
        self.types = types
        self.tags = tags
    }
    
    func findRelevantClips(completion: @escaping (_ ids: [(key:Int,value:Int)]) -> Void)
    {
        let platforms: [Int:Platforms] = [0:Platforms.Instagram,1:Platforms.Youtube]
        
        var checkIDs: [Int] = []
        
        for platform in platforms {
            if types.contains(platform.value) {
                checkIDs.append(platform.key)
            }
        }
        
        for clipID in checkIDs
        {
            Clip.getClip(from: clipID)
            { (clip) in
                var unorderedList: [Int:Int] = [:]
                for tag in clip.tags
                {
                    for tag2 in self.tags
                    {
                        if tag.name.lowercased() == tag2.name.lowercased()
                        {
                            if unorderedList[clip.id] != nil
                            {
                                // The clip has already been matched with one tag.
                                // Add another match.
                                
                                let matches = unorderedList[clip.id]
                                unorderedList[clip.id] = matches! + 1
                            } else
                            {
                                // The clip has not yet been matched with a tag.
                                // Set its value to 1.
                                
                                unorderedList[clip.id] = 1
                            }
                        }
                    }
                }
                
                // The for-loop check has finished.
                // All values are accurate.
                // Order the list.
                let orderedList: [(key:Int,value:Int)] = unorderedList.sorted { $1.1 > $0.1 }
                completion(orderedList)
            }
        }
        
        
    }
    
    public static func supportingClips(profile: Profile, completion: @escaping (_ clips: [Int]) -> Void) {
        
        let supporting = profile.supporting
        var count = 0
        if supporting?.count != 0
        {
            var mediaIDs: [Int] = []
            for prof in supporting!
            {
                Account.getProfileUID(tag: prof)
                { (profID) in
                    
                    // Get all 'profID' media.
                    Account.getProfile(userID: profID, completion:
                        { (userProfile) in
                            
                        if userProfile.clips?.count != nil
                        {
                            mediaIDs.append(contentsOf: userProfile.clips!)
                        }
                        count += 1
                        if count == supporting?.count {
                            completion(mediaIDs)
                        }
                            
                    })
                }
            }
            
        } else {
            completion([])
        }
        
        // Convert STRING to UID
        // From UID grab clip IDS
        // Return clip IDS
    }
    
    public static func orderByDate(relevantClips: [Clip]) -> [(key:Int,value:Double)] {
        
        var unorderedList: [Int:Double] = [:]
        
        for clip in relevantClips
        {
            let publishedDate = clip.date
            let timeSincePublish = DGTime.timeFrom(date: publishedDate)
            unorderedList[clip.id] = timeSincePublish
        }
        
        let orderedList = unorderedList.sorted { $0.1 < $1.1 }
        return orderedList
    }
}
