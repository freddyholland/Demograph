//
//  Auth.swift
//  Demograph
//
//  Created by Frederick Holland on 24/04/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class Account {
    
    public static func create(email: String, password: String, local_tag: String, name: String, platforms: [Platform], completionHandler: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: {
            (result, error) in
            guard let user = result?.user, error == nil else {
                // There was an error generating an account
                completionHandler(false, error)
                print(error!)
                return
            }
            
            let profile = Profile(id: user.uid, local_tag: local_tag.lowercased(), name: name, picture: Placeholders.picture!, banner: Placeholders.banner!, platforms: [], bio: "", supporting: [], supporters: [], clips: [])
            saveProfile(profile: profile, completion: {
                success in
                
                if success {
                    print("account successfully created")
                    /*updateUsername(profile: profile, tag: local_tag, completion: {
                        success in
                        if !success {
                            print("An error occurred updating the created profile's username to the userbase.")
                        }
                    })*/
                } else {
                    completionHandler(false, error)
                }
            })
            let emailData = ["email":email]
            Firestore.firestore().collection("users").document(user.uid).setData(emailData, merge: true)
            //Firestore.firestore().collection("users").document(user.uid).setValue(email, forKey: "email")
            completionHandler(true, error)
        })
    }
    
    public static func updateSupporting(profile: Profile)
    {
        let id = profile.id
        let supporting = profile.supporting!
        Firestore.firestore().collection("users").document(id).setData(["supporting":supporting], merge: true)
        //Firestore.firestore().collection("users").document(id).setValue(supporting, forKey: "supporting")
    }
    
    /*public static func updateUsername(profile: Profile, tag: String, completion: @escaping (_ success: Bool) -> Void) {
        print("attempting to download userbase document")
        Firestore.firestore().collection("info").document("userbase").getDocument
            { (snapshot, error) in
                
                print("updating userbase")
                if let error = error {
                    print("An error occurred: \(error)")
                    completion(false)
                    return
                }
                
                print("no errors, downloading data")
                var data = snapshot?.data() as? [String:String] ?? [:]
                if (data[profile.local_tag] != nil) {
                    data.removeValue(forKey: profile.local_tag)
                }
                
                data[tag] = profile.id
                
                Firestore.firestore().collection("info").document("userbase").setData(data)
                completion(true)
        }
    }*/
    
    public static func attemptLogin(email: String, password: String, completionHandler: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: {
            (result, error) in
            guard let _ = result?.user, error == nil else {
                // There was an error generating an account
                completionHandler(false, error)
                print(error!)
                return
            }
            
            completionHandler(true, error)
        })
    }
    
    public static func userTagExists(user_tag: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        Firestore.firestore().collection("users").getDocuments(completion: {
            (snapshot, error) in
            if let error = error {
                print(error)
            } else {
                for document in snapshot!.documents {
                    if(!document.exists) {
                        continue
                    }
                    if(document.get("local_tag") == nil) {
                        continue
                    }
                    let local_tag: String = document.get("local_tag") as! String
                    if local_tag.lowercased() == user_tag.lowercased() {
                        completionHandler(true)
                        return
                    }
                }
                
                completionHandler(false)
            }
        })
    }
    
    /*public static func getProfileUID(tag: String, completion: @escaping (_ uid: String) -> Void) {
        Firestore.firestore().collection("info").document("userbase").getDocument
            { (snapshot, error) in
                if let error = error {
                    print("An error occurred: \(error)")
                    return
                }
                print("Data: \(snapshot?.data())")
                print("Tag: \(tag)")
                let userList = snapshot?.data()! as? [String:String] ?? [:]
                if !userList[tag.lowercased()].isEmpty {
                    completion(userList[tag.lowercased()]!)
                } else {
                    completion("")
                }
        }
    }*/
    
    public static func getProfile(userID: String, completion: @escaping (_ user: Profile) -> Void) {
        let profile = Profile(id: userID, local_tag: "", name: "", picture: UIImage(), banner: UIImage(), platforms: [], bio: "", supporting: [], supporters: [], clips: [])
        
        print("attempting to get profile")
        Firestore.firestore().collection("users").document(userID).getDocument(completion: {
            (snapshot, error) in
            
            if let error = error {
                print(error)
                print("there was an aerror")
                return
            }
            
            print("checking for local_tag")
            if (snapshot?.get("local_tag") != nil)
                && (snapshot?.get("name") != nil)
                && (snapshot?.get("email") != nil) {
                
                // All necessary fields are available.
                print("Stage 1 pass")
                
                profile.local_tag = snapshot?.get("local_tag") as! String
                profile.name = snapshot?.get("name") as! String
                
                if snapshot?.get("bio") != nil {
                    profile.bio = snapshot?.get("bio") as! String as String
                }
                
                if snapshot?.get("platforms") != nil {
                    print("grabbing items from /platforms")
                    let platformArrays = snapshot?.get("platforms") as! [[String:String]]
                    var platforms:[Platform] = []
                    for platformArray in platformArrays {
                        platforms.append(Platform.getPlatform(from: platformArray))
                    }
                    profile.platforms = platforms
                }
                
                if snapshot?.get("supporting") != nil {
                    print("grabbing items from /supporting")
                    let supporting = snapshot?.get("supporting") as! [String]
                    profile.supporting = supporting
                } else {
                    profile.supporting = []
                }
                
                if snapshot?.get("clips") != nil {
                    print("grabbing items from /clips")
                    let clips = snapshot?.get("clips") as! [Int]
                    profile.clips = clips
                } else {
                    profile.clips = []
                }
                
                Bucket.getUserPicture(id: userID, completion: {
                    image in
                    profile.picture = image
                    print("Picture image loaded")
                    Bucket.getUserBanner(id: userID, completion: {
                        image in
                        profile.banner = image
                        print("Banner image loaded")
                        
                        completion(profile)
                        print("Profile returned in completion handler")
                    })
                })
                
                print("### \(profile.local_tag), \(profile.name), \(profile.id)")
            }
            
        })
        
        
    }
    
    public static func saveProfile(profile: Profile, completion: @escaping (_ success: Bool) -> Void) {
        print("### Recieved request to save Profile")
        let id = profile.id
        var data: [String:Any] = [
            "local_tag":profile.local_tag.lowercased(),
            "name":profile.name,
            "bio":profile.bio!,
            "clips":profile.clips!,
            "supporting":profile.supporting!
        ]
        
        print(profile.id)
        
        /*if profile.clips?.count != 0 {
            data["clips"] = profile.clips
            //ref.setValue(profile.clips, forKey: "clips")
        }*/
        
        if profile.platforms?.count != 0 {
            var platforms:[[String:String]] = []
            for platform in profile.platforms! {
                platforms.append(Platform.getDictionary(from: platform))
            }
            data["platforms"] = platforms
            //ref.setValue(platforms, forKey: "platforms")
        } else {
            data["platforms"] = []
        }
        
        Firestore.firestore().collection("users").document(id).setData(data, merge: true) { err in
            if let err = err {
                print("### Error writing document: \(err)")
                completion(false)
            } else {
                print("### Document successfully written!")
                /*updateUsername(profile: profile, tag: profile.local_tag, completion: {
                    success in
                    if !success {
                        print("An error occurred updating the value of the users local_tag in the userbase.")
                    }
                })*/
                completion(true)
            }
        }
        
        Bucket.saveUserPicture(profile: profile)
        Bucket.saveUserBanner(profile: profile)

        
    }
}
