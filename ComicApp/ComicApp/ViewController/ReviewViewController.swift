//
//  ReviewViewController.swift
//  ComicApp
//
//  Created by Le Van Anh on 12/30/19.
//  Copyright © 2019 Le Van Anh. All rights reserved.
//

import UIKit
import Firebase

class ReviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Comment.listReviewWorld.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cmtcell", for: indexPath) as! commentTableViewCell
        let db = Firestore.firestore()
        db.collection("Comment").document(Comment.listReviewWorld[Comment.listReviewWorld.count - indexPath.row - 1]).getDocument { (document, error) in
            if error == nil{
                cell.lblContent.text = document?.data()!["content"] as? String
                let storage = Storage.storage()
                let storageRef = storage.reference().child("User/" + (document?.data()!["userID"] as? String)! + ".jpg")
                storageRef.getData(maxSize: 7 * 1024 * 1024) { data, error in
                    if error == nil {
                        cell.imgAvatarUser.layer.cornerRadius = 30
                        cell.imgAvatarUser.contentMode = .scaleAspectFill
                        cell.imgAvatarUser.image = UIImage(data: data!)
                    }
                }
                var str1 = ""
                var str2 = ""
                print((document?.data()!["userID"] as? String)!)
                db.collection("Users").document((document?.data()!["userID"] as? String)!).getDocument { (doc1, err1) in
                    if err1 == nil{
                        str1 = doc1?.data()!["fullName"] as! String
                        if str2 != "" && str1 != ""{
                            Utilities.setLblTwoColor(cell.lblUserAndComic, str1, str2)
                        }
                    }
                }
                db.collection("Comic").document(document?.data()!["comicID"] as! String).getDocument { (doc2, err2) in
                    if err2 == nil{
                        str2 = doc2?.data()!["name"] as! String
                        if str1 != "" && str2 != ""{
                            Utilities.setLblTwoColor(cell.lblUserAndComic, str1, str2)
                        }
                    }
                }
                
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let db = Firestore.firestore()
        db.collection("Comment").document(Comment.listReviewWorld[Comment.listReviewWorld.count - indexPath.row - 1]).getDocument { (document, error) in
            if error == nil{
                Comic.id = document?.data()!["comicID"] as? String
                self.performSegue(withIdentifier: "showInfo", sender: self)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
