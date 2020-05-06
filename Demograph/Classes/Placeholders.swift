//
//  Placeholders.swift
//  Demograph-Prototype
//
//  Created by Frederick Holland on 01/04/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import Foundation
import UIKit

class Placeholders {
    
    public static let userAccount = Profile(id: "",
        local_tag: "",
        name: "",
        picture: UIImage(),
        banner: UIImage(),
        platforms: [],
        bio: "",
        supporting: [],
        supporters: [],
        clips: [1])
    
    public static let picture = UIImage(named: "default_picture")
    public static let banner = UIImage(named: "default_banner")
    public static let emptyClip = Clip(url: "", title: "", publisher: "", date: "", platform: Platforms.Email, platformTag: "", id: 0, thumbnail: "", tags: [])
    public static let temporary_preference = Preference(types: [Platforms.Youtube, Platforms.Spotify, Platforms.Instagram], tags: [Tag(name: "sypher"), Tag(name: "fortnite")])
    
    public static let green = UIColor(red: 96/255, green: 175/255, blue: 95/255, alpha: 1)
    public static let dark_green = UIColor(red: 63/255, green: 116/255, blue: 63/255, alpha: 1)
    
}

/*
 clips: [
 Clip(url: "https://www.youtube.com/watch?v=7rQhBlTkvt4", title: "Welcome to my channel.", date: "01.04.20", time: "12:09", platform: Platforms.Youtube, platformTag: "Freddy Holland", id: 1, tags: []),
 Clip(url: "https://www.twitch.tv/myth/clip/ArbitraryArborealWoodcockDxCat?filter=clips&range=7d&sort=time", title: "Look at that knife", date: "01.04.20", time: "19:23", platform: Platforms.Twitch, platformTag: "Myth", id: 2, tags: []),
 Clip(url: "https://open.spotify.com/track/3hjSJFD7CgqzIfjt0bRFtn", title: "I'm A Ghost", date: "01.04.20", time: "19:23", platform: Platforms.Spotify, platformTag: "Hilltop Hoods", id: 2, tags: []),
 Clip(url: "https://soundcloud.com/bigwax/wax-music-and-liquor", title: "Music & Liquor", date: "01.04.20", time: "19:23", platform: Platforms.Soundcloud, platformTag: "Big Wax", id: 2, tags: []),
 Clip(url: "https://www.instagram.com/p/BzVw1v0lZbq/", title: "Harden showing some love", date: "01.04.20", time: "19:23", platform: Platforms.Instagram, platformTag: "jamesharden", id: 2, tags: [])])
 */
