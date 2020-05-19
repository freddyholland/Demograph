//
//  Preference.swift
//  Demograph
//
//  Created by iMac on 3/5/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

class Preference {
    
    public static var current = Preference(types: [], tags: [])
    
    var types: [Platforms]
    var tags: [String]
    
    init(types: [Platforms], tags: [String])
    {
        self.types = types
        self.tags = tags
    }
    
    func findRelevantClips(range: Int, completion: @escaping (_ clips: [Clip]) -> Void)
    {
        
        Clip.loadClips(range: range) { (loadedClips) in
            var toOrder: [Int:Clip] = [:]
            var unorderedList: [Int:Int] = [:]
            
            // Initial check - clips filter through if the platform is consistent with the Preference.
            for loadedClip in loadedClips {
                if self.types.contains(loadedClip.platform) {
                    toOrder[loadedClip.id] = loadedClip
                }
            }
            
            for unorderedClipSet in toOrder
            {
                let unorderedClip = unorderedClipSet.value
                unorderedList[unorderedClip.id] = 0
                for tag in unorderedClip.tags
                {
                    for tag2 in self.tags
                    {
                        if tag.lowercased() == tag2.lowercased()
                        {
                            //if unorderedList[unorderedClip.id] != nil
                            //{
                            let matches = unorderedList[unorderedClip.id]!
                                unorderedList[unorderedClip.id] = matches + 1
                            //} else
                            //{
                            //    unorderedList[unorderedClip.id] = 1
                            //}
                        }
                    }
                }
            }
            
            let orderedList = unorderedList.sorted { $1.1 > $0.1 }
            
            var forCompletion: [Clip] = []
            for returnedIDSet in orderedList
            {
                let returnedID = returnedIDSet.key
                forCompletion.append(toOrder[returnedID]!)
            }
            completion(forCompletion)
            
        }
        
        
    }
    
    public static func supportingClips(profile: Profile, completion: @escaping (_ clips: [Int]) -> Void) {
        
        var count = 0
        if profile.supporting?.count != 0
        {
            
            let supporting = profile.supporting!
            var mediaIDs: [Int] = []
            for prof in supporting
            {
                Account.getProfile(userID: prof)
                { (userProfile) in
                    if userProfile.clips?.count != 0
                    {
                        mediaIDs.append(contentsOf: userProfile.clips!)
                    }
                    count += 1
                    if count == supporting.count {
                        completion(mediaIDs)
                    }
                }
            }
            
        } else {
            completion([])
        }
        
        // Convert STRING to UID
        // From UID grab clip IDS
        // Return clip IDS
    }
    
    public static func orderByDate(relevantClips: [Clip]) -> [Clip] {
        
        var idList: [Int:Clip] = [:]
        var unorderedList: [Int:Double] = [:]
        
        for clip in relevantClips
        {
            idList[clip.id] = clip
            let publishedDate = clip.date
            let timeSincePublish = DGTime.timeFrom(date: publishedDate)
            unorderedList[clip.id] = timeSincePublish
        }
        
        var reorderedClips: [Clip] = []
        let orderedList = unorderedList.sorted { $0.1 < $1.1 }
        for item in orderedList {
            reorderedClips.append(idList[item.key]!)
        }
        return reorderedClips
    }
    
    public static func getSavedPreference(forUser: String, completion: @escaping (_ preference: Preference) -> Void) {
        
        let ref = Firestore.firestore().collection("users").document(forUser)
        
        
        let preference: Preference = Preference(types: [], tags: [])
        ref.getDocument
            { (snapshot, err) in
                
                if let err = err {
                    //DGAlert.errorAlert(with: 205, controller: self)
                    
                    return
                }
                
                
                
                if let snap_platforms = snapshot?.get("preferred_platforms") {
                    
                    
                    let platformStrings = snap_platforms as! [String]
                    var platforms: [Platforms] = []
                    for string in platformStrings {
                        platforms.append(Platforms(rawValue: string)!)
                    }
                    
                    preference.types = platforms
                    
                }
                
                if let snap_tags = snapshot?.get("preferred_tags") {
                    let tagStrings = snap_tags as! [String]
                    
                    preference.tags = tagStrings
                }
                
                completion(preference)
                
        }
        
    }
    
    func savePreference(forUser: String) {
        
        let ref = Firestore.firestore().collection("users").document(forUser)
        
        let platforms = self.types
        let tags = self.tags
        
        var stringPlatforms: [String] = []
        for platform in platforms {
            stringPlatforms.append(platform.rawValue)
        }
        
        var data = ["preferred_platforms":stringPlatforms, "preferred_tags":tags]
        
        ref.setData(data, merge: true)
    }
    
}
