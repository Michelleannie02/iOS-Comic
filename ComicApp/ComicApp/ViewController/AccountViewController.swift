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
    
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblBirthday: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setAccount()
    }
    func setAccount(){
        btnLoginLogout.title = "Login"
        //btnEdit.isHidden = true
        //btnChangePassword.isHidden = true
        self.lblFullName.text = UserLocal.localAccount.name
        self.lblGender.text = UserLocal.localAccount.gender
        self.lblBirthday.text = UserLocal.localAccount.birthday
        self.lblEmail.text = UserLocal.localAccount.email
        if UserLocal.localAccount.avatar == nil {
            self.imgAvatar.image = UIImage(systemName: "person.circle")
        }
        else{
            self.imgAvatar.contentMode = .scaleAspectFill
            self.imgAvatar.image = UIImage(data: UserLocal.localAccount.avatar!)
        }
//        if (UserLocal.UserID != nil) {
//            //
//            btnLoginLogout.title = "Logout"
//            btnEdit.isHidden = false
//            btnChangePassword.isHidden = false
//            let db = Firestore.firestore()
//            let ref = db.collection("Users").document(UserLocal.UserID!)
//            ref.getDocument { (document, error) in
//                if let document = document, document.exists {
//                    let data = document.data()
//                    self.lblFullName.text = data?["fullName"] as? String
//                    self.lblGender.text = "Male"
//                    self.lblBirthday.text = "Null"
//                }
//            }
//        }
//        else{
//            //
//            btnLoginLogout.title = "Login"
//            //btnEdit.isHidden = true
//            //btnChangePassword.isHidden = true
//            self.lblFullName.text = "Guest"
//            self.lblGender.text = "Null"
//            self.lblBirthday.text = "Null"
//            self.lblEmail.text = "Null"
//        }
    }

}
