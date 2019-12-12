//
//  User.swift
//  ComicApp
//
//  Created by Le Van Anh on 12/10/19.
//  Copyright © 2019 Le Van Anh. All rights reserved.
//

import Foundation
import UIKit

class UserLocal{
    static var UserID: String?
}
class User:NSObject {
    var email: String?
    var fullName: String?
    
    init(Email: String,name: String){
        self.email = Email
        self.fullName = name
    }
    func toAnyObjects() -> Any {
        return ["email":email,"fullName":fullName]
    }
}
