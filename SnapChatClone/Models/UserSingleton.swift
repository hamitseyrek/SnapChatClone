//
//  UserSingleton.swift
//  SnapChatClone
//
//  Created by Hamit Seyrek on 9.02.2022.
//

import Foundation

class UserSingleton {
    static let sharedInstance = UserSingleton()
    var email = ""
    var userName = ""
    private init(){
        
    }
}
