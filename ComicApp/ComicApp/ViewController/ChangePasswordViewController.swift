//
//  ChangePasswordViewController.swift
//  ComicApp
//
//  Created by Le Van Anh on 12/17/19.
//  Copyright © 2019 Le Van Anh. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var txtCurrentPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    
    @IBOutlet weak var txtRetypeNewPassword: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var lblError: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setElement()
    }
    func setElement(){
        txtCurrentPassword.delegate = self
        txtNewPassword.delegate = self
        txtRetypeNewPassword.delegate = self
        lblError.alpha = 0
        Utilities.styleFilledButton(btnSend)
    }
    func validateFields() -> String? {
       //check that all fields are filled in
       if txtCurrentPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || txtNewPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || txtRetypeNewPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
           return "Please fill all fields."
       }
       //check password
        if txtNewPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) != txtRetypeNewPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines){
            return "You must enter the same password twice in order to confirm it."
        }
       let cleanedPassword = txtNewPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
       if Utilities.isPasswordValid(cleanedPassword) == false {
           return "Please make sure your new password is at least 8 characters, contains a special character and a number."
       }
       
       return nil
    }

     func showError(_ error: String){
         lblError.text = error
         lblError.alpha = 1
     }
    @IBAction func Send(_ sender: Any) {
        let error = validateFields()
        if error == nil{
            let fAuth = Auth.auth()
                fAuth.signIn(withEmail: UserLocal.localAccount.email!, password: txtCurrentPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)) { (result, error) in
                if error != nil {
                    self.showError(error!.localizedDescription)
                }
                else {
                    fAuth.currentUser?.updatePassword(to: self.txtNewPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)) { (error) in
                        if error != nil{
                            print(error!)
                            self.showError("Faild")
                        }
                        else{
                            self.self.showError("Successful!")
                            self.txtNewPassword.text = ""
                            self.txtCurrentPassword.text = ""
                            self.txtRetypeNewPassword.text = ""
                        }
                    }
                }
            }            
        }
        else{
            showError(error!)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
