//
//  EditAccountViewController.swift
//  ComicApp
//
//  Created by Le Van Anh on 12/17/19.
//  Copyright © 2019 Le Van Anh. All rights reserved.
//

import UIKit

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
        gender = "Other"
        txtBirthday.text = UserLocal.localAccount.birthday
        txtName.text = UserLocal.localAccount.name
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
            //update firebase
            
            
            
            //set edit
            
            UserLocal.localAccount.name = txtName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            UserLocal.localAccount.birthday = txtBirthday.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            UserLocal.localAccount.gender = gender
            UserLocal.localAccount.avatar = imageAvatar.pngData() ?? nil
            UserLocal.saveAccount()
            self.transitionToHome()
        }
    }
    func transitionToHome(){
        let initialViewController = self.storyboard?.instantiateViewController(identifier: "HomeVC")
        self.view.window?.rootViewController = initialViewController
        self.view.window?.makeKeyAndVisible()
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //imgAvatar.contentMode = .scaleAspectFill
            imgAvatar.image = pickedImage
            imageAvatar = pickedImage
        }
     
        dismiss(animated: true, completion: nil)
    }
}
