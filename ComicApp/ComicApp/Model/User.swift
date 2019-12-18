//
//  User.swift
//  ComicApp
//
//  Created by Le Van Anh on 12/10/19.
//  Copyright © 2019 Le Van Anh. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Firebase

class UserLocal{
    static var UserID: String?
    static var localAccount = LUser()
    static func downAccount(){
        let db = Firestore.firestore()
        if UserLocal.UserID == nil{
            let realm = try! Realm()
            if let user = realm.objects(LUser.self).first{
               localAccount.name = user.name
               localAccount.birthday = user.birthday
               localAccount.gender = user.gender
               localAccount.email = user.email
               localAccount.avatar = user.avatar
            }
        }
        else{
            let ref = db.collection("Users").document(UserLocal.UserID!)
            ref.getDocument { (document, error) in
               if error != nil{
                   //error
                  
               } else{
                   if let document = document, document.exists {
                       let data = document.data()
                       localAccount.name = data?["fullName"] as? String
                       localAccount.gender = data?["gender"] as? String
                       localAccount.birthday = data?["birthday"] as? String
                   }
                   
                   //load email va avata tu firebase
               }
           }
        }
    }
    static func saveAccount(){
        let realm = try! Realm()
        //save User id
        
        
        //
        
        
        
        if let user = realm.objects(LUser.self).first{
            try! realm.write {
                user.name = localAccount.name
                user.gender = localAccount.gender
                user.birthday = localAccount.birthday
                user.email = localAccount.email
                user.avatar = localAccount.avatar
            }
        } else{
            try! realm.write {
                realm.add(localAccount)
            }
        }
    }
}
//class User:NSObject {
//    var email: String?
//    var fullName: String?
//    init(Email: String,name: String){
//        self.email = Email
//        self.fullName = name
//    }
//    func toAnyObjects() -> Any {
//        return ["email":email,"fullName":fullName]
//    }
//}
class LUser: Object {
    @objc dynamic var name : String? = "Guest"
    @objc dynamic var gender :String? = "Other"
    @objc dynamic var email :String? = "guest@gmail.com"
    @objc dynamic var birthday : String? = "01/01/2000"
    @objc dynamic var avatar : Data? = nil
}

