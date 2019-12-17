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
    
    @IBOutlet weak var btnEdit: UIButton!
    
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
        if (UserLocal.UserID != nil) {
            //
            btnLoginLogout.title = "Logout"
//            btnLoginLogout.setTitle("Logout", for: .normal)
            let db = Firestore.firestore()
            let ref = db.collection("Users").document(UserLocal.UserID!)
            ref.getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    self.lblFullName.text = data?["fullName"] as? String
                    self.lblGender.text = "Male"
                    self.lblBirthday.text = "Null"
//                    self.lblFirstName.text = data?["firstName"] as? String
//                    self.lblLastName.text = data?["lastName"] as? String
                }
            }
        }
        else{
            //
            btnLoginLogout.title = "Login"
            btnEdit.isHidden = true
            self.lblFullName.text = "Guest"
            self.lblGender.text = "Null"
            self.lblBirthday.text = "Null"
            self.lblEmail.text = "Null"
        }
    }
}
