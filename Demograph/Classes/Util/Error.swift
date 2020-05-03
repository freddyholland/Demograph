//
//  Error.swift
//  Demograph
//
//  Created by iMac on 2/5/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import Foundation

class DGError {
    
    public static func errormsg(id: Int) {
        
        var message = ""
        
        switch id {
        case 100:
            return
        case 101:
            return
        case 102:
            return
        case 103:
            return
        default:
            message = "An unknown error occurred. Please feel free to contact the support team: support@fjcode.net"
        }
    }
}
