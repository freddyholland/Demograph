//
//  Profile.swift
//  Demograph-Prototype
//
//  Created by Frederick Holland on 01/04/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class Profile {
    
    var local_tag: String
    var name: String
    var platforms: [Platform]?
    var supporting: [String]?
    var supporters: [String]?
    var clips: [Int]?
    var id: String
    var bio: String?
    var picture: UIImage?
    var banner: UIImage?
    
    init(id: String, local_tag:String, name:String, picture:UIImage, banner:UIImage, platforms:[Platform], bio:String, supporting: [String], supporters:[String], clips:[Int]) {
        self.id = id
        self.local_tag = local_tag
        self.name = name
        self.platforms = platforms
        self.supporting = supporting
        self.supporters = supporters
        self.clips = clips
        self.bio = bio
        self.picture = picture
        self.banner = banner
    }
    
    func getShareablePlatforms() -> [Platform] {
        
        var shareablePlatforms: [Platform] = []
        
        if platforms?.count != 0 {
            for platform in platforms! {
                switch platform.type {
                case .Instagram, .Soundcloud, .Spotify, .Twitch, .Youtube:
                    shareablePlatforms.append(platform)
                default:
                    continue
                }
            }
        }
        
        return shareablePlatforms
        
    }
    
    func removeClip(withID: Int, completion: @escaping (_ success: Bool) -> Void) {
        
        // Check if the user has a clip with specified ID
        if !(self.clips?.contains(withID) ?? false) {
            // User doesn't have a clip with the specified ID.
            completion(false)
        }
        
        // Update the users [clips]
        self.clips = self.clips?.filter( { $0 == withID } )
        
        // Set this instance of Profile as the current and save to the database.
        Profile.current = self
        Profile.attemptSaveCurrent { (_) in }
        
        let clips_reference = Firestore.firestore().collection("clips")
        clips_reference.document("\(withID)").delete
            { (err) in
                if let error = err {
                    print("An error occurred: \(error)")
                    completion(false)
                } else {
                    completion(true)
                }
        }
    }
    
    public static var current: Profile = Profile(id: "", local_tag: "", name: "", picture: UIImage(), banner: UIImage(), platforms: [], bio: "", supporting: [], supporters: [], clips: [])
    
    public static func attemptLoadCurrent(completion: @escaping (_ success: Bool) -> Void) {
        print("function called in class")
        print(Auth.auth().currentUser!.uid)
        if Auth.auth().currentUser != nil {
            print("current user DOESNT = nil")
            Account.getProfile(userID: Auth.auth().currentUser!.uid, completion: {
                profile in
                current = profile
                print("completion = true")
                completion(true)
            })
        } else {
            print("an error occured!!! completion = false")
            completion(false)
        }
    }
    
    // Call when modiciations are made.
    public static func attemptSaveCurrent(completion: @escaping (_ success:Bool) -> Void) {
        print("### Attempting to save current Profile with UID \(current.id)")
        Account.saveProfile(profile: current, completion: {
            success in
            completion(success)
        })
    }
}
