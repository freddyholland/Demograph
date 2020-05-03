//
//  Bucket.swift
//  Demograph
//
//  Created by iMac on 28/4/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

class Bucket {
    
    private static let storage = Storage.storage().reference()
    
    public static func saveUserPicture(profile: Profile) {
        let id = profile.id
        print("### ID = \(id)")
        let userPictureRef = storage.child("users/pictures/\(profile.id).jpg")
        
        print("attempting to save users picture")
        // Upload the file to the path "images/rivers.jpg"
        userPictureRef.putData((profile.picture?.jpegData(compressionQuality: 0.25))!, metadata: nil) { (metadata, error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    public static func saveUserBanner(profile: Profile) {
        let userPictureRef = storage.child("users/banners/\(profile.id).jpg")
        
        print("attempting to save users banner")
        
        userPictureRef.putData((profile.banner?.jpegData(compressionQuality: 0.25))!, metadata: nil, completion: {
            (metadata, error) in
            if let error = error {
                print(error)
            }
        })
    }
    
    public static func getUserPicture(id: String, completion: @escaping (_ image: UIImage) -> Void) {
        let userPictureRef = storage.child("users/pictures/\(id).jpg")
        
        print("retrieving user picture")
        
        userPictureRef.getData(maxSize: 1 * 512 * 512, completion: {
            (data, error) in
            if let error = error {
                print(error)
                completion(Placeholders.picture!)
                return
            } else {
                let image = UIImage(data: data!)
                completion(image!)
            }
            
        })
    }
    
    public static func getUserBanner(id: String, completion: @escaping (_ image: UIImage) -> Void) {
        let userPictureRef = storage.child("users/banners/\(id).jpg")
        
        userPictureRef.getData(maxSize: 1 * 1500 * 408, completion: {
            (data, error) in
            
            if let error = error {
                print(error)
                completion(Placeholders.banner!)
                return
            } else {
                let image = UIImage(data: data!)
                completion(image!)
            }
            
        })
    }
}
