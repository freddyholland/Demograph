//
//  Tag.swift
//  Demograph-Prototype
//
//  Created by Frederick Holland on 24/04/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import Foundation

class Tag {
    var name: String
    
    init(name:String) {
        self.name = name.lowercased()
    }
    
    private static var tags: [Tag] = [Tag(name: "youtube"), Tag(name: "spotify"), Tag(name: "soundcloud"), Tag(name: "instagram")]
    
    public static func getTags() -> [Tag] {
        // Retrieve all tags from Firebase
        return tags
    }
    
    public static func tagExists(tag:String) -> Bool {
        
        // Same principle but tags is retrieved from Firebase
        
        for t in tags {
            if(tag.lowercased() == t.name.lowercased()) {
                return true
            }
        }
        
        return false
    }
    
    public static func reloadTags() {
        // Get Firebase reference
        // Download Firebase content as [String]
        // Convert [String] into [Tag]
        // Update value of 'tags'
    }
    
}
