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
    static func setLblTwoColor(_ lbl: UILabel, _ str1: String,_ str2: String){
        let attrs1 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor : UIColor.black]

        let attrs2 = [NSAttributedString.Key.font : UIFont.italicSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor : UIColor.link]

        let attributedString1 = NSMutableAttributedString(string:str1 + " - ", attributes:attrs1)

        let attributedString2 = NSMutableAttributedString(string:str2, attributes:attrs2)

        attributedString1.append(attributedString2)
        lbl.attributedText = attributedString1
    }
    static func styleButtonLike(_ btn: UIButton){
        switch btn.tag {
        case 0:
            btn.layer.backgroundColor = UIColor.systemPurple.cgColor
            btn.tintColor = UIColor.white
            btn.layer.borderColor = UIColor.systemPurple.cgColor
            btn.layer.borderWidth = 2
            break;
        default:
            btn.layer.backgroundColor = UIColor.white.cgColor
            btn.tintColor = UIColor.systemPurple
            btn.layer.borderColor = UIColor.systemPurple.cgColor
            btn.layer.borderWidth = 2
        }
    }
    static func stylteTextField(_ textField:UITextField){
        
        textField.borderStyle = .line
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.black.cgColor
    }

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
    static func fixTypeSize(_ size:Int64) -> String{
        if size < 1024 {
            return "\(size) Byte"
        }
        else if size < 1024 * 1024{
            return "\(Int(size/1024)) KB"

        }
        else if size < 1024 * 1024 * 1024{
            return "\(Int(size/(1024 * 1024))) MB"
        }
        else if size < 1024 * 1024 * 1024 * 1024{
            return "\(Int(size/(1024 * 1024 * 1024))) GB"
        }
        else if size < 1024 * 1024 * 1024 * 1024 * 1024{
            return "\(Int(size/(1024 * 1024 * 1024 * 1024))) TG"
        }
        return ""
    }
}
