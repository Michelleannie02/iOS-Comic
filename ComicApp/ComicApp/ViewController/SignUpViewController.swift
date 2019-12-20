//
//  SignUpViewController.swift
//  ComicApp
//
//  Created by Le Van Anh on 12/9/19.
//  Copyright © 2019 Le Van Anh. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var lblError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setElement()
    }
    func setElement(){
        lblError.alpha = 0
        Utilities.styleFilledButton(btnSignUp)
    }
    //check the fields
    func validateFields() -> String? {
       //check that all fields are filled in
       if txtFullName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || txtPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
           return "Please fill all fields."
       }
       //check password
       let cleanedPassword = txtPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
       if Utilities.isPasswordValid(cleanedPassword) == false {
           return "Please make sure your password is at least 8 characters, contains a special character and a number."
       }
       
       return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        //Validate the fields
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        }
        else
        {
            //create cleaned vaersions of the data
            let fullName = txtFullName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = txtEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = txtPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the User
            Auth.auth().createUser(withEmail: email, password: password) { (results, error) in
                //check for error
                if error != nil {
                    self.showError("Error create user")
                }
                else {
                    //User was create successfully, now store the first name and last name
                    let db = Firestore.firestore()
                    db.collection("Users").document(results!.user.uid).setData(["uid":results!.user.uid,"fullName":fullName, "gender":"Other","birthday":"01/01/2000","avatarUrl":"","email":email]) { (error) in
                        if error != nil {
                            self.showError("Error saving user data")
                        }
                    }
                    // Transition to the home screen
                    UserLocal.UserID = results!.user.uid
                    self.transitionToHome()
                }
            }
        }
    }
    func showError(_ error: String){
        lblError.text = error
        lblError.alpha = 1
    }
    func transitionToHome(){
        let initialViewController = self.storyboard?.instantiateViewController(identifier: "HomeVC")
        self.view.window?.rootViewController = initialViewController
        self.view.window?.makeKeyAndVisible()
    }
    
}
