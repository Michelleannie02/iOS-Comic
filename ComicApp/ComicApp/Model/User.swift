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
import Network

class UserLocal{
    static var UserID: String?
    static var localAccount = User()
    static func userRealmToRam(){
        let realm = try! Realm()
        if let user = realm.objects(LUser.self).first{
            UserLocal.UserID = user.userID
            UserLocal.localAccount.fullName = user.name
            UserLocal.localAccount.gender = user.gender
            UserLocal.localAccount.birthday = user.birthday
            UserLocal.localAccount.email = user.email
            UserLocal.localAccount.avatar = user.avatar
        }
    }
    static func userFirebaseToRam(){
        let db = Firestore.firestore()
        let ref = db.collection("Users").document(UserLocal.UserID!)
        ref.getDocument { (document, error) in
            if error != nil{
                UserLocal.localAccount.isDownAvatar = false
            } else{
                if let document = document, document.exists {
                    let data = document.data()
                    UserLocal.localAccount.fullName = data?["fullName"] as? String
                    UserLocal.localAccount.gender = data?["gender"] as? String
                    UserLocal.localAccount.birthday = data?["birthday"] as? String
                    UserLocal.localAccount.email = data?["email"] as? String
                    if data?["avatarUrl"] as? String == "" {
                        UserLocal.localAccount.avatar = nil
                        userRamToRealm()
                    }
                    else {
                        UserLocal.localAccount.isDownAvatar = true
                        let storage = Storage.storage()
                        let storageRef = storage.reference().child("User/" + UserLocal.UserID! + ".jpg")

                        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                        storageRef.getData(maxSize: 7 * 1024 * 1024) { data, error in
                            if error == nil {
                                UserLocal.localAccount.avatar = data!
                                UserLocal.localAccount.isDownAvatar = false
                                userRamToRealm()
                            }
                        }
                    }
                }
            }
        }
    }
    static func downAccount(){
        let realm = try! Realm()
        if let user = realm.objects(LUser.self).first{
            UserLocal.UserID = user.userID
        }
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "InternetConnectionMonitor")
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                Utilities.isNetworkConnect = true
                if UserLocal.UserID != nil{
                    userFirebaseToRam()
                }
            }
            else{
                userRealmToRam()
                Utilities.isNetworkConnect = false
                UserLocal.localAccount.isDownAvatar = false
            }
        }
        monitor.start(queue: queue)
        monitor.currentPath.isExpensive
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
//        let db = Firestore.firestore()
//        let realm = try! Realm()
//        if let user = realm.objects(LUser.self).first{
//            UserLocal.UserID = user.userID
//            UserLocal.localAccount.fullName = user.name
//            UserLocal.localAccount.gender = user.gender
//            UserLocal.localAccount.birthday = user.birthday
//            UserLocal.localAccount.email = user.email
//            UserLocal.localAccount.avatar = user.avatar
//            let ref = db.collection("Users").document(UserLocal.UserID!)
//            ref.getDocument { (document, error) in
//                if error != nil{
//                    UserLocal.localAccount.isDownAvatar = false
//                } else{
//                    if let document = document, document.exists {
//                        let data = document.data()
//                        UserLocal.localAccount.fullName = data?["fullName"] as? String
//                        UserLocal.localAccount.gender = data?["gender"] as? String
//                        UserLocal.localAccount.birthday = data?["birthday"] as? String
//                        UserLocal.localAccount.email = data?["email"] as? String
//                        if data?["avatarUrl"] as? String == "" {
//                            UserLocal.localAccount.avatar = nil
//                            saveAccount()
//                        }
//                        else {
//                            UserLocal.localAccount.isDownAvatar = true
//                            let storage = Storage.storage()
//                            let storageRef = storage.reference().child("User/" + UserLocal.UserID! + ".jpg")
//
//                            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
//                            storageRef.getData(maxSize: 7 * 1024 * 1024) { data, error in
//                                if error == nil {
//                                    UserLocal.localAccount.avatar = data!
//                                    UserLocal.localAccount.isDownAvatar = false
//                                    saveAccount()
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        else{
//            if UserLocal.UserID != nil{
//                let ref = db.collection("Users").document(UserLocal.UserID!)
//                ref.getDocument { (document, error) in
//                    if error != nil{
//                        //error
//                        UserLocal.localAccount.isDownAvatar = false
//                    } else{
//                        if let document = document, document.exists {
//                            let data = document.data()
//                            UserLocal.localAccount.fullName = data?["fullName"] as? String
//                            UserLocal.localAccount.gender = data?["gender"] as? String
//                            UserLocal.localAccount.birthday = data?["birthday"] as? String
//                            UserLocal.localAccount.email = data?["email"] as? String
//                            if data?["avatarUrl"] as? String == "" {
//                                UserLocal.localAccount.avatar = nil
//                                saveAccount()
//                            }
//                            else {
//                                UserLocal.localAccount.isDownAvatar = true
//                                let storage = Storage.storage()
//                                let storageRef = storage.reference().child("User/" + UserLocal.UserID! + ".jpg")
//
//                                // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
//                                storageRef.getData(maxSize: 7 * 1024 * 1024) { data, error in
//                                    if error == nil {
//                                        UserLocal.localAccount.avatar = data!
//                                        UserLocal.localAccount.isDownAvatar = false
//                                        saveAccount()
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            else{
//                UserLocal.localAccount = User()
//            }
//        }
    }
    static func userRamToRealm(){
        let realm = try! Realm()

        if let user = realm.objects(LUser.self).first{
            try! realm.write {
                user.avatar = localAccount.avatar
                user.birthday = localAccount.birthday
                user.email = localAccount.email
                user.gender = localAccount.gender
                user.name = localAccount.fullName
//                realm.delete(user)
//                realm.add(LUser(value: ["name": localAccount.fullName ?? "","email": localAccount.email ?? "","gender":localAccount.gender ?? "","birthday":localAccount.birthday ?? "","avatar":localAccount.avatar ?? Data() ,"userID":UserLocal.UserID ?? ""]))
            }
        } else{
            try! realm.write {
                realm.add(LUser(value: ["name": localAccount.fullName ?? "","email": localAccount.email ?? "","gender":localAccount.gender ?? "","birthday":localAccount.birthday ?? "","avatar":localAccount.avatar ?? Data() ,"userID":UserLocal.UserID ?? ""]))
            }
        }
    }
    static func deleteAccount(){
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(LUser.self))
        }
    }
    
}
class User:NSObject {
    var email: String? = "guest@gmail.com"
    var fullName: String? = "Guest"
    var gender: String? = "Other"
    var birthday: String? = "01/01/2000"
    var avatar: Data? = nil
    var isDownAvatar: Bool = false
}


