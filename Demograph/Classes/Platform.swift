//
//  Platform.swift
//  Demograph-Prototype
//
//  Created by Frederick Holland on 31/03/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import Foundation

class Platform {
    var type: Platforms
    var userTag: String
    var userName: String
    //var userInfo: [String]
    
    init(type: Platforms, userTag: String, userName:String/*, userInfo: [String]*/) {
        self.type = type
        self.userTag = userTag
        self.userName = userName
        //self.userInfo = userInfo
    }
    
    public static func getPlatform(from:[String]) -> Platform {
        return Platform(type: Platforms(rawValue: from[0])!, userTag: from[1], userName: from[2])
    }
    
    public static func getArray(from:Platform) -> [String] {
        var array: [String] = []
        array.append(from.type.rawValue)
        array.append(from.userTag)
        array.append(from.userName)
        return array
    }
    
    public static func determinePlatformFrom(url_string: String) -> Platforms {
        /*
         https://www.youtube.com/watch?v=7rQhBlTkvt4
         https://www.twitch.tv/myth/clip/ArbitraryArborealWoodcockDxCat?filter=clips&range=7d&sort=time
         https://open.spotify.com/track/3hjSJFD7CgqzIfjt0bRFtn
         https://soundcloud.com/bigwax/wax-music-and-liquor
         https://www.instagram.com/p/BzVw1v0lZbq/
         */
        let url = URL(string: url_string)
        let domain = url?.host?
            .replacingOccurrences(of: ".com", with: "")
            .replacingOccurrences(of: ".tv", with: "")
            .replacingOccurrences(of: "www.", with: "")
            .replacingOccurrences(of: "open.", with: "")
        
        switch domain {
        case Platforms.Instagram.rawValue.lowercased():
            return Platforms.Instagram
        case Platforms.Soundcloud.rawValue.lowercased():
            return Platforms.Soundcloud
        case Platforms.Spotify.rawValue.lowercased():
            return Platforms.Spotify
        case Platforms.Twitch.rawValue.lowercased():
            return Platforms.Twitch
        case Platforms.Youtube.rawValue.lowercased():
            return Platforms.Youtube
        default:
            return Platforms.Email
        }
    }
}

enum Platforms : String {
    
    case Youtube // Thumbnail download & content accessible. X
    case Instagram // Content accessible & square thumbnail available. X
    
    case Spotify // Content accessible but no thumbnail (excluding API)
    case Soundcloud // Content accessible but same situation as spotify
    case Twitch // Content accessible and API required for thumbnail.
    
    case Snapchat // Disabled.
    case Email // Disabled.
    case Facebook // Disabled.
    case Twitter // Disabled.
}
