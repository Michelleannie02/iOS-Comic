//
//  InfoViewController.swift
//  ComicApp
//
//  Created by KiD on 12/11/19.
//  Copyright © 2019 Le Van Anh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import RealmSwift

class InfoViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var infView: UIView!
    @IBOutlet weak var cmtView: UIView!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var btnShowComment: UIButton!
    
    @IBOutlet weak var readButton: UIButton!
    
    @IBAction func readChap(_ sender: Any) {
        Comic.chap = 0
    }
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    
    @IBOutlet weak var chap: UIButton!
    @IBOutlet weak var btnDownload: UIButton!
    
    @IBOutlet weak var lblReview: UILabel!
    

    
    
    @IBOutlet weak var txtComment: UITextField!
    
    
    @IBOutlet weak var staComment: UIView!
    @IBOutlet weak var staFixKeyboard: UIStackView!
    @IBOutlet weak var tbvComment: UITableView!
    
    @IBAction func Like(_ sender: Any) {
        if UserLocal.UserID != nil{
            likeButton.tag = 1 - likeButton.tag
            Utilities.styleButtonLike(likeButton)
            if likeButton.tag == 0{
                let db = Firestore.firestore()
                db.collection("Users").document(UserLocal.UserID!).updateData(["comicLike": FieldValue.arrayRemove([Comic.id ?? ""])])
                //delete list cpu
                var i = 0
                for check in Shelf.listLike{
                    if check.idComic == Comic.id{
                        Shelf.listLike.remove(at: i)
                        break;
                    }
                    i += 1
                }
            }
            else{
                let db = Firestore.firestore()
                let storage = Storage.storage()
                db.collection("Users").document(UserLocal.UserID!).updateData(["comicLike": FieldValue.arrayUnion([Comic.id ?? ""])])
                //add to list cpu
                let comictmp = DComic()
                comictmp.idComic = Comic.id
                comictmp.finish = true
                db.collection("Comic").document(Comic.id!).getDocument { (document, error) in
                    if error == nil{
                        comictmp.name = document?.data()?["name"] as? String
                        comictmp.totalChap = document?.data()?["totalChap"] as? Int
                        let posterPath = document?.data()?["posterPath"] as? String
                        storage.reference().child(posterPath!).getData(maxSize: 7*1024*1024) { (data, error) in
                            if error == nil{
                                comictmp.poster = data!
                                Shelf.listLike.append(comictmp)
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    @IBAction func ShowComment(_ sender: Any) {
        btnShowComment.tag = 1 - btnShowComment.tag
        Utilities.styleButtonLike(btnShowComment)
        cmtView.isHidden = !cmtView.isHidden
        if UserLocal.UserID != nil{
            staComment.isHidden = !staComment.isHidden
        }
        tbvComment.reloadData()
    }
    @IBAction func sendComment(_ sender: Any) {
        if txtComment.text != ""{
            let db = Firestore.firestore()
            var ref: DocumentReference? = nil
            ref = db.collection("Comment").addDocument(data: ["userID": UserLocal.UserID ?? "","comicID": Comic.id ?? "", "content": txtComment.text ?? ""]) { (error) in
                if error == nil{
                    // add to list Comic
                    db.collection("Comic").document(Comic.id!).updateData(["comment": FieldValue.arrayUnion([ref!.documentID])])
                    //add to list world
                    db.collection("Comment").document("listCommentID").updateData(["listComment": FieldValue.arrayUnion([ref!.documentID])])
                    Comment.listCommentComic.append(ref!.documentID)
                    Comment.listReviewWorld.append(ref!.documentID)
                    self.tbvComment.reloadData()
                }
            }
            txtComment.text = ""
        }
    }
    
    @IBAction func Download(_ sender: Any) {
        btnDownload.isHidden = true
        Comic.isDowloading += 1
        Shelf.DownloadCommic(Comic.id!)
    }
    
    func upLoad ()
    {
        let tmp = DComic()
        tmp.finish = true
        tmp.idComic = Comic.id
        let storage = Storage.storage()
        let db = Firestore.firestore()
        let ref = db.collection("Comic").document(Comic.id!)
        ref.getDocument { (document, error) in
            if error == nil{
                tmp.name = document?.data()?["name"] as? String
                self.name.text = document?.data()?["name"] as? String
                self.lblAuthor.text = "Tác giả: " + ((document?.data()?["author"] as? String)!)
                self.lblCategory.text = "Thể loại: " + ((document?.data()?["category"] as? String)!)
            }
        }
        let storageRef = storage.reference().child("Comic/" + Comic.id!)
        
        storageRef.listAll { (result, error) in
            if error != nil {
                return
            }
            // code
            for _ in result.prefixes {
                
                self.chap.setTitle( "Chap Mới Nhất: Chap " + String(result.prefixes.count), for: .normal)
                Comic.nchap = result.prefixes.count
                tmp.totalChap = result.prefixes.count
                
            }
            
            for item in result.items {
                // The items under storageReference.
                item.getData(maxSize: 7 * 1024 * 1024) { data, error in
                    if error != nil {
                // Uh-oh, an error occurred!
                        return
                    }
                    tmp.poster = data!
                    var check = true
                    for indexComic in Shelf.listHistory{
                        if indexComic.idComic == tmp.idComic{
                            check = false
                            break
                        }
                    }
                    if check{
                        Shelf.listHistory.append(tmp)
                    }
                    let image = UIImage(data: data!)
                    self.imgView.image = image
                    self.imgView.contentMode = .scaleAspectFill
                }
            }
        }
    }
    func loadComicFromRealm() -> Bool{
        let realm = try! Realm()
        let comics = realm.objects(LComic.self)
        for comic in comics{
            if comic.comicID == Comic.id{
                self.imgView.image = UIImage(data: comic.comicPoster!)
                self.imgView.contentMode = .scaleAspectFill
                self.chap.setTitle( "Chap Mới Nhất: Chap " + String(comic.comicNChap), for: .normal)
                Comic.isDownloaded = true
                Comic.nchap = comic.comicNChap
                btnDownload.isHidden = true
                return false
            }
        }
        return true
    }
    
    func addToHistory(){
        if UserLocal.UserID != nil{
            let db = Firestore.firestore()
            db.collection("Users").document(UserLocal.UserID!).updateData(["comicHistory": FieldValue.arrayUnion([Comic.id ?? ""])])
        }
    }
    @IBAction func beginComment(_ sender: Any) {
        
    }
    @IBOutlet weak var test: UIScrollView!

    func setHeightFixKey(_ keyboardHeight: Int){
        var height = keyboardHeight
        for binaryHeight in staFixKeyboard.subviews {
            binaryHeight.isHidden = true
            if height % 2 == 1{
                height -= 1
                binaryHeight.isHidden = false
            }
            height /= 2
        }
    }
    var keyboardHeight : Int = 0
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = Int(keyboardRectangle.height)
            test.contentInset.bottom = keyboardRectangle.height
            test.verticalScrollIndicatorInsets.bottom = keyboardRectangle.height
            setHeightFixKey(keyboardHeight)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        Comic.isDownloaded = false
        if loadComicFromRealm(){
            upLoad()
            addToHistory()
        }
        else{
            upLoad()
            addToHistory()
        }
        // check list like
        likeButton.tag = 0
        for check in Shelf.listLike{
            if check.idComic == Comic.id{
                likeButton.tag = 1
                break
            }
        }
        Utilities.styleButtonLike(likeButton)
        btnShowComment.tag = 0
        Utilities.styleButtonLike(btnShowComment)
        
        Comment.listCommentComic = [String]()
        Comment.downloadListCommentComic(Comic.id!)
        
        likeButton.layer.cornerRadius = 25
        likeButton.clipsToBounds = true
        
        btnShowComment.layer.cornerRadius = 25
        btnShowComment.clipsToBounds = true
        
        btnDownload.layer.cornerRadius = 25
        btnDownload.clipsToBounds = true
    
        readButton.layer.cornerRadius = 25
        readButton.clipsToBounds = true
        
        
        infView.layer.cornerRadius = 25
        cmtView.layer.cornerRadius = 25

        chap.layer.cornerRadius = 20
        chap.clipsToBounds = true
        
        lblReview.layer.cornerRadius = 20
        lblReview.clipsToBounds = true
        
    }
    


}

extension InfoViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Comment.listCommentComic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cmtcell", for: indexPath) as! commentTableViewCell
        let db = Firestore.firestore()
        db.collection("Comment").document(Comment.listCommentComic[indexPath.row]).getDocument { (document, error) in
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
}

extension InfoViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        setHeightFixKey(0)
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
