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
            
            Firestore.firestore().collection("users").document(user.uid).setData(["id":user.uid, "local_tag":local_tag.lowercased(),"name":name,"email":email])
            completionHandler(true, error)
        })
    }
    
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
    
    public static func getProfile(userID: String, completion: @escaping (_ user: Profile) -> Void) {
        let profile = Profile(id: userID, local_tag: "", name: "", platforms: [], bio: "", supporters: [], clips: [])
        
        Firestore.firestore().collection("users").document(userID).getDocument(completion: {
            (snapshot, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            if (snapshot?.get("local_tag") != nil)
                && (snapshot?.get("name") != nil)
                && (snapshot?.get("email") != nil) {
                
                // All necessary fields are available.
                
                profile.local_tag = snapshot?.get("local_tag") as! String
                profile.name = snapshot?.get("name") as! String
                
                if snapshot?.get("bio") != nil {
                    profile.bio = snapshot?.get("bio") as? String
                }
                
                if snapshot?.get("platforms") != nil {
                    let platformArrays = snapshot?.get("platforms") as! [[String]]
                    var platforms:[Platform] = []
                    for platformArray in platformArrays {
                        platforms.append(Platform.getPlatform(from: platformArray))
                    }
                }
                
                if snapshot?.get("supporters") != nil {
                    print("Supporters yet to be implemented")
                    // MARK:- Implement support for supporters function.
                }
                
                completion(profile)
                print("### \(profile.local_tag), \(profile.name), \(profile.id)")
            }
            
        })
    }
    
    public static func saveProfile(profile: Profile) {
        print("### Recieved request to save Profile")
        let id = profile.id
        var data: [String:Any] = ["local_tag":profile.local_tag.lowercased(),"name":profile.name,"bio":profile.bio!]
        /*ref.setValue(profile.local_tag, forKey: "local_tag")
        ref.setValue(profile.name, forKey: "name")
        ref.setValue(profile.bio, forKey: "bio")*/
        
        if profile.clips?.count != 0 {
            data["clips"] = profile.clips
            //ref.setValue(profile.clips, forKey: "clips")
        }
        if profile.platforms?.count != nil {
            var platforms:[[String]] = []
            for platform in profile.platforms! {
                platforms.append(Platform.getArray(from: platform))
            }
            data["platforms"] = platforms
            //ref.setValue(platforms, forKey: "platforms")
        }
        if profile.supporters?.count != 0 {
            //ref.setValue(profile.supporters, forKey: "supporters")
        }
        
        Firestore.firestore().collection("users").document(id).setData(data, merge: true) { err in
            if let err = err {
                print("### Error writing document: \(err)")
            } else {
                print("### Document successfully written!")
            }
        }

        
    }
}
