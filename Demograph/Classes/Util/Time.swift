//
//  Time.swift
//  Demograph
//
//  Created by iMac on 4/5/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import Foundation

class DGTime {
    
    public static func getDate() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = format.string(from: date)
        return formattedDate
    }
    
    public static func timeFrom(date: String) -> Double {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let sinceDate = formatter.date(from: date)!
        let since = Date().timeIntervalSince(sinceDate)
        
        return since
    }
    
}
