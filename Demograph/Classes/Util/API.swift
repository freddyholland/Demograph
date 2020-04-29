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
    public static func getTwitchThumbnail(from: Clip, completion: @escaping (_ imageURL: String) -> Void) {
        let headers: HTTPHeaders = [
            "Client-ID":"",
            "Accept":""
        ]
        if from.platform != Platforms.Twitch {
            return
        }
        let url = "https://api.twitch.tv/kraken/clips/\(from.url)"
        
        AF.request(url, headers: headers)
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
        .responseJSON { response in
            switch response.result {
            case .success:
                print("Validation Successful")
                let json = JSON(response.value!)
                let imageURL = json["thumbnails"]["medium"].stringValue
                completion(imageURL)
                print(json)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    public static func getSpotifyThumbnail(from: Clip, completion: @escaping (_ imageURL: String) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization: Bearer ":"",
        ]
        if from.platform != Platforms.Spotify {
            return
        }
        let url = "https://api.spotify.com/v1/tracks/\(from.url)"
        
        AF.request(url, headers: headers)
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
        .responseJSON { response in
            switch response.result {
            case .success:
                print("Validation Successful")
                let json = JSON(response.value!)
                let imageURL = json["album"]["images"].arrayValue[1].stringValue
                completion(imageURL)
                print(json)
            case let .failure(error):
                print(error)
            }
        }
    }
}
