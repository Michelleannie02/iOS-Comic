//
//  Utilities.swift
//  ComicApp
//
//  Created by Le Van Anh on 12/10/19.
//  Copyright © 2019 Le Van Anh. All rights reserved.
//

import Foundation
import UIKit
import Network


class Utilities{
    static var isNetworkConnect: Bool = true
//    static func isNetwork(){
//        let monitor = NWPathMonitor()
//        let queue = DispatchQueue(label: "InternetConnectionMonitor")
//        monitor.pathUpdateHandler = { path in
//            if path.status == .satisfied {
//                print("asjdhakjsdhhadajhsds")
//            }
//            else{
//                UserLocal.localAccount.isDownAvatar = false
//                print(333333333)
//            }
//        }
//        monitor.start(queue: queue)
//        monitor.currentPath.isExpensive
//    }
    static func stylteTextField(_ textField:UITextField){
        
        textField.borderStyle = .line
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.black.cgColor
    }
//    static func styleCircleButton(_ button: UIButton){
//        button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
//        button.layer.cornerRadius = 25
//        button.tintColor = UIColor.white
//    }
    static func styleFilledButton(_ button: UIButton){
        button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        button.layer.cornerRadius = 24
        button.tintColor = UIColor.white
    }
    static func styleHellowButton(_ button: UIButton){
        button.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25
        button.tintColor = UIColor.black
    }
    static func isPasswordValid(_ password: String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$")
        return passwordTest.evaluate(with: password)
    }
    static func styleAvatar(_ img: UIImageView){
        img.layer.cornerRadius = 100
        img.contentMode = .scaleAspectFill
        img.layer.borderWidth = 10
        img.layer.borderColor = UIColor.white.cgColor
    }
}
