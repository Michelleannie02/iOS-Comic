//
//  EditAccountViewController.swift
//  ComicApp
//
//  Created by Le Van Anh on 12/17/19.
//  Copyright © 2019 Le Van Anh. All rights reserved.
//

import UIKit
import Firebase

class EditAccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtBirthday: UITextField!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnOther: UIButton!
    @IBOutlet weak var lblError: UILabel!
    
    var gender: String?
    let imagePicker = UIImagePickerController()
    var imageAvatar = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        setElement()
    }
    func setElement(){

            lblError.alpha = 0
            gender = UserLocal.localAccount.gender
            switch gender {
            case "Other":
                SelectGender(btnOther)
                break;
            case "Male":
                SelectGender(btnMale)
                break;
            case "Female":
                SelectGender(btnFemale)
                break;
            default:
                SelectGender(btnOther)
            }
            txtBirthday.text = UserLocal.localAccount.birthday
            txtName.text = UserLocal.localAccount.fullName
            imgAvatar.layer.cornerRadius = 100
            if UserLocal.localAccount.avatar != nil{
                imgAvatar.contentMode = .scaleAspectFill
                imgAvatar.image = UIImage(data: UserLocal.localAccount.avatar!)
            }
            //load gender
            
        }
    

    @IBAction func ChangeAvatar(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
            
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func Male(_ sender: Any) {
        SelectGender(btnMale)
    }
    @IBAction func Female(_ sender: Any) {
        SelectGender(btnFemale)
    }
    @IBAction func Other(_ sender: Any) {
        SelectGender(btnOther)
    }
    func SelectGender(_ btnGender: UIButton!){
        btnMale.setImage(UIImage(systemName: "circle"), for: .normal)
        btnFemale.setImage(UIImage(systemName: "circle"), for: .normal)
        btnOther.setImage(UIImage(systemName: "circle"), for: .normal)
        btnGender.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
        gender = btnGender.title(for: .normal)!
    }
    @IBAction func Save(_ sender: Any) {
        if txtName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || txtBirthday.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            lblError.text = "Please fill all fields."
            lblError.alpha = 1
        }
        else{
            let db = Firestore.firestore()
            db.collection("Users").document(UserLocal.UserID!).updateData(["fullName":txtName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Error","birthday":txtBirthday.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "01/01/2000","gender":gender ?? "Other"])
            if let data = imageAvatar.pngData(){
                let storage = Storage.storage()
                let storageRef = storage.reference()
                let riversRef = storageRef.child("User/" + UserLocal.UserID! + ".jpg")
                riversRef.putData(data, metadata: nil) { (metadata, error) in
                    if metadata != nil {
                        riversRef.downloadURL { (url, error) in
                            if url != nil {
                                db.collection("Users").document(UserLocal.UserID!).updateData(["avatarUrl":url?.absoluteString ?? ""])
                            }
                        }
                        self.transitionToHome()
                    }
                }
            }
            else
            {
                self.transitionToHome()
            }
        }
    }
    func transitionToHome(){
        let initialViewController = self.storyboard?.instantiateViewController(identifier: "HomeVC")
        self.view.window?.rootViewController = initialViewController
        self.view.window?.makeKeyAndVisible()
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgAvatar.contentMode = .scaleAspectFill
            imgAvatar.layer.cornerRadius = 100
            imgAvatar.image = pickedImage
            imageAvatar = pickedImage
        }
     
        dismiss(animated: true, completion: nil)
    }
}
