//
//  Error.swift
//  Demograph
//
//  Created by iMac on 2/5/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import Foundation

class DGError {
    
    public static func errormsg(id: Int) -> String {
        
        var message = ""
        
        switch id {
            
        case 101:
            message = "Not all required fields contain an input."
        case 102:
            message = "The passwords don't match."
        case 103:
            message = "The entered username already exists. Try another."
        case 104:
            message = "The username is too short. A username must be longer than 4 characters."
        case 105:
            message = "There are illegal characters in the username. A username may only contain 'a-z' '0-9' underscores and periods."
        case 106:
            message = "An account already exists with the entered email address. Try logging in instead."
        case 107:
            message = "The entered Media ID is invalid. Double check it leads to a post and the selected Platform is accurate."
            
        case 201:
            message = "An error occurred attempting to sign in. Are you using the correct login details?"
        case 202:
            message = "An error occurred loading the signed-in profile."
        case 203:
            message = "An error occurred attempting to create this account."
        case 204:
            message = "An error occurred attempting to upload this post."
        case 205:
            message = "An error occurred attempting to retrieve user preferences."
        case 206:
            message = "An error occurred trying to save user preferences."
            
        case 301:
            message = "You currently have no configured platforms for sharing. You can manage these in Profile > Manage > Manage Platforms"
            
        default:
            message = "An unknown error occurred. Please feel free to contact the support team: support@fjcode.net"
        }
        
        return message
        
    }
}
