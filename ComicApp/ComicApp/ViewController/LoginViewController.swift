//
//  LoginViewController.swift
//  ComicApp
//
//  Created by Le Van Anh on 12/9/19.
//  Copyright © 2019 Le Van Anh. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var lblError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setElement()
    }
    func setElement(){
        txtEmail.delegate = self
        txtPassword.delegate = self
        lblError.alpha = 0
        Utilities.styleFilledButton(btnLogin)
        Utilities.styleHellowButton(btnSignUp)
        //delete old account
        UserLocal.UserID = nil
        UserLocal.localAccount = User()
        Shelf.listHistory = [DComic]()
        Shelf.listLike = [DComic]()
        UserLocal.deleteAccount()
    }
    

    @IBAction func loginTapped(_ sender: Any) {
        // Validate text fields
        if txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || txtPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            showError("Please fill all fields.")
        }
        else
        {
            //create
            let email = txtEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = txtPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // signing in the user
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    self.showError(error!.localizedDescription)
                }
                else {
                    UserLocal.UserID = result!.user.uid
                    self.transitionToHome()
                }
            }
        }
    }
    
    @IBAction func CancelLogin(_ sender: Any) {
        transitionToHome()
    }
    //    @IBAction func CancelLogin(_ sender: Any) {
//        transitionToHome()
//    }
    func transitionToHome(){
        Shelf.DownloadList()
        UserLocal.localAccount.isDownAvatar = true
        self.dismiss(animated: true, completion: {})
        self.navigationController?.popToRootViewController(animated: true)
//        let initialViewController = self.storyboard?.instantiateViewController(identifier: "HomeVC")
//        self.view.window?.rootViewController = initialViewController
//        self.view.window?.makeKeyAndVisible()
    }
    func showError(_ error: String){
        lblError.text = error
        lblError.alpha = 1
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
