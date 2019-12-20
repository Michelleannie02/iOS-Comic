//
//  AccountViewController.swift
//  ComicApp
//
//  Created by Le Van Anh on 12/9/19.
//  Copyright © 2019 Le Van Anh. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {
   
   
    @IBOutlet weak var btnLoginLogout: UIBarButtonItem!
    
    @IBOutlet weak var btnChangePassword: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var imgAvatar: UIImageView!
    
    @IBOutlet weak var aivLoad: UIActivityIndicatorView!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblBirthday: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    //design
    @IBOutlet weak var lblMyAccount: UILabel!
    @IBOutlet weak var lblAccount: UILabel!
    @IBOutlet weak var lblAbout: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setAccount()
    }
    func setAccount(){
        lblAccount.layer.masksToBounds = true
        lblAccount.layer.cornerRadius = 12
        lblAccount.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        lblAbout.layer.masksToBounds = true
        lblAbout.layer.cornerRadius = 12
        lblAbout.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        lblMyAccount.layer.masksToBounds = true
        lblMyAccount.layer.cornerRadius = 20
        Utilities.styleAvatar(imgAvatar)
        btnLoginLogout.title = "Login"
        btnEdit.isHidden = true
        btnChangePassword.isHidden = true
        self.lblFullName.text = UserLocal.localAccount.fullName
        self.lblMyAccount.text = UserLocal.localAccount.fullName
        self.lblGender.text = UserLocal.localAccount.gender
        self.lblBirthday.text = UserLocal.localAccount.birthday
        self.lblEmail.text = UserLocal.localAccount.email
        if UserLocal.localAccount.avatar == nil {
            self.imgAvatar.image = UIImage(systemName: "person.circle")
        }
        else{
            self.imgAvatar.image = UIImage(data: UserLocal.localAccount.avatar!)
        }
        if UserLocal.localAccount.isDownAvatar == true{
            aivLoad.startAnimating()
            let storage = Storage.storage()
            let storageRef = storage.reference().child("User/" + UserLocal.UserID! + ".jpg")
            storageRef.getData(maxSize: 7 * 1024 * 1024) { data, error in
                if error == nil {
                    self.imgAvatar.image = UIImage(data: data!)
                    self.aivLoad.stopAnimating()
                }
            }
        }
        
        if (UserLocal.UserID != nil) {
            //
            btnLoginLogout.title = "Logout"
            btnEdit.isHidden = false
            btnChangePassword.isHidden = false
        }
    }
    
}
