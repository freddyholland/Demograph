//
//  API.swift
//  Demograph
//
//  Created by iMac on 28/4/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class API {
    
    private static let twitch_client = "7l4l1glp48f1drnp1pif5lpck9s9h7"
    
    // MARK: - Twitch API
    
    public static func getTwitchClip(id: String, completion: @escaping (_ clip: Clip) -> Void)
    {
        // Establish required headers.
        let headers: HTTPHeaders = [
            "Client-ID":twitch_client,
            "Accept":"application/vnd.twitchtv.v5+json"
        ]
        
        // Establish variables.
        let url = "https://api.twitch.tv/kraken/clips/\(id)"
        let clip = Clip(url: "", title: "", date: "", time: "", platform: Platforms.Twitch, platformTag: "", id: 0, thumbnail: "", tags: [])
        
        // Make the request.
        AF.request(url, headers: headers)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"]).responseJSON
            { (response) in
                
                switch response.result
                {
                case .success:
                    
                    // Success retrieving JSON data.
                    let json = JSON(response.value!)
                    clip.url = json["url"].stringValue
                    clip.title = json["title"].stringValue
                    //clip.date = system.getDate
                    //clip.time = system.getTime
                    clip.platformTag = json["curator"]["displayname"].stringValue
                    clip.thumbnail = json["thumbnails"]["medium"].stringValue
                    clip.id = Clip.generateID()
                    
                    completion(clip)
                    
                case let .failure(error):
                    
                    // There was an error retrieving the data.
                    print(error)
                    completion(clip)
                    
                }
        }
    }
    
    // MARK: - Spotify API
    
    public static func getSpotifyClip(id: String, completion: @escaping (_ clip: Clip) -> Void)
    {
        // Establish required headers.
        
        let clip = Clip(url: "https://open.spotify.com/track/\(id)", title: "", date: "", time: "", platform: Platforms.Spotify, platformTag: "", id: Clip.generateID(), thumbnail: "", tags: [])
        completion(clip)
        /*let headers: HTTPHeaders = [
            "Authorization: Bearer ":self.spotify_client
        ]
        
        // Establish variables.
        let url = "https://api.spotify.com/v1/tracks/\(id)"
        let clip = Clip(url: "", title: "", date: "", time: "", platform: Platforms.Spotify, platformTag: "", id: 0, thumbnail: "", tags: [])
        print(url)
        
        // Make the request.
        AF.request(url, headers: headers)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"]).responseJSON(completionHandler:
            { (response) in
                
                switch response.result
                {
                case .success:
                    
                    // Success retrieving JSON data.
                    let json = JSON(response.value!)
                    clip.url = json["external_urls"]["spotify"].stringValue
                    clip.title = json["name"].stringValue
                    //clip.date = system.getDate
                    //clip.time = system.getTime
                    clip.platformTag = json["artists"]["name"][0].stringValue
                    clip.thumbnail = json["images"][2]["url"].stringValue
                    clip.id = Clip.generateID()
                    
                    completion(clip)
                    
                case let .failure(error):
                    
                    // There was an error retrieving the data.
                    print(error)
                    completion(clip)
                    
                }
                
            })*/
    }
    
    // MARK: - Soundcloud API
    
    public static func getSoundcloudClip(id: String, publisher: Platform, completion: @escaping (_ clip: Clip) -> Void)
    {
        
        let clip = Clip(url: "https://soundcloud.com/\(publisher.userTag)/\(id)", title: "", date: "", time: "", platform: Platforms.Soundcloud, platformTag: "", id: Clip.generateID(), thumbnail: "", tags: [])
        completion(clip)
        
        /*
        // Establish variables.
        let url = "https://api.soundcloud.com/tracks/\(id)?client_id=\(id)"
        let clip = Clip(url: "", title: "", date: "", time: "", platform: Platforms.Soundcloud, platformTag: "", id: 0, thumbnail: "", tags: [])
        
        // Make the request.
        AF.request(url)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"]).responseJSON
            { (response) in
                
                switch response.result
                {
                case .success:
                    
                    // Success retreieving JSON data.
                    let json = JSON(response.value!)
                    clip.url = json["permalink_url"].stringValue
                    clip.title = json["title"].stringValue
                    //clip.date = system.getDate
                    //clip.time = system.getTime
                    clip.platformTag = json["user"]["username"].stringValue
                    clip.thumbnail = json["artwork_url"].stringValue
                    clip.id = Clip.generateID()
                    
                    completion(clip)
                    
                case let .failure(error):
                    
                    // There was an error retrieving the data.
                    print(error)
                    completion(clip)
                    
                }
        }*/
    }
    
    public static func getInstagramClip(id: String, completion: @escaping (_ clip: Clip) -> Void)
    {
        let clip = Clip(url: "https://www.instagram.com/p/\(id)", title: "", date: "", time: "", platform: Platforms.Instagram, platformTag: "", id: Clip.generateID(), thumbnail: "https://www.instagram.com/p/\(id)/media/?size=m", tags: [])
        completion(clip)
    }
    
    public static func getYoutubeClip(id: String, completion: @escaping (_ clip: Clip) -> Void)
    {
        let clip = Clip(url: "https://www.youtube.com/watch?v=\(id)", title: "", date: "", time: "", platform: Platforms.Youtube, platformTag: "", id: Clip.generateID(), thumbnail: "https://i1.ytimg.com/vi/\(id)/mqdefault.jpg", tags: [])
        completion(clip)
    }
}