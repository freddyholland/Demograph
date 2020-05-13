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
            
            print("Under Preference.swift/findRelevantClips(_): downloaded \(loadedClips.count) before filtering.")
            
            // Initial check - clips filter through if the platform is consistent with the Preference.
            for loadedClip in loadedClips {
                if self.types.contains(loadedClip.platform) {
                    toOrder[loadedClip.id] = loadedClip
                }
            }
            
            print("Under Preference.swift/findRelevantClips(_): there are \(toOrder.count) clips available after filtering.")
            
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
            
            print("unofficially: \(unorderedList)")
            
            let orderedList = unorderedList.sorted { $1.1 > $0.1 }
            print("Under Preference.swift/findRelevantClips(_): returning a total \(orderedList.count) clips after complete filtering.")
            
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
        print("% if \(profile.supporting?.count) > 0")
        if profile.supporting?.count != 0
        {
            print("passed")
            let supporting = profile.supporting!
            var mediaIDs: [Int] = []
            for prof in supporting
            {
                print("Under Preference.swift: attempting to download all media data from \(prof) UID. ")
                Account.getProfile(userID: prof)
                { (userProfile) in
                    print("unofficially after download: \(userProfile.local_tag) & \(userProfile.clips?.count)")
                    if userProfile.clips?.count != 0
                    {
                        print("\(userProfile.clips?.count) clips have been downloaded from under 'Account.getProfile(_)'.")
                        mediaIDs.append(contentsOf: userProfile.clips!)
                    }
                    count += 1
                    print("Under Preference.swift: there are ( \(count)/\(supporting.count) ) supported users been read, with a returning \(mediaIDs.count) clips.")
                    if count == supporting.count {
                        print("Completion fired with \(mediaIDs.count) clips returning.")
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
        
        print("attempting to load preference from ref-point")
        let preference: Preference = Preference(types: [], tags: [])
        ref.getDocument
            { (snapshot, err) in
                
                if let err = err {
                    //DGAlert.errorAlert(with: 205, controller: self)
                    print(err)
                    return
                }
                
                print("no errors occurred")
                
                if let snap_platforms = snapshot?.get("preferred_platforms") {
                    print("successfully downloaded at least 1 platform")
                    
                    let platformStrings = snap_platforms as! [String]
                    var platforms: [Platforms] = []
                    for string in platformStrings {
                        print("cycling through platform \(string)")
                        platforms.append(Platforms(rawValue: string)!)
                    }
                    
                    preference.types = platforms
                    print("\(platforms.count) platforms returned.")
                    
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
