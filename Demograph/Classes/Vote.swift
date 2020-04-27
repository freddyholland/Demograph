//
//  Vote.swift
//  Demograph-Prototype
//
//  Created by Frederick Holland on 24/04/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import Foundation

class Vote {
    var from: String
    var plus: Bool
    var post: Int
    
    init(from:String, plus:Bool, post:Int) {
        self.from = from
        self.plus = plus
        self.post = post
    }
    
    func toDB() -> [Any] {
        let array: [Any] = [self.post, self.from, self.plus]
        return array
    }
    
    public static func toVote(from:[Any]) -> Vote? {
        if(from.count != 2) {
            return nil
        }
        let vote = Vote(from: from[1] as! String, plus: from[2] as! Bool, post: from[0] as! Int)
        return vote
    }
}
