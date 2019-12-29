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
    
    @IBOutlet weak var readButton: UIButton!
    
    @IBAction func readChap(_ sender: Any) {
        Comic.chap = 0
    }
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    
    @IBOutlet weak var chap: UIButton!
    @IBOutlet weak var btnDownload: UIButton!
    
    
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
                    i += 1
                    if check.idComic == Comic.id{
                        Shelf.listLike.remove(at: i)
                        break;
                    }
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
                        storage.reference().child(posterPath!).getData(maxSize: 1024*1024) { (data, error) in
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
    @IBAction func Download(_ sender: Any) {
        btnDownload.isHidden = true
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
                item.getData(maxSize: 1 * 1024 * 1024) { data, error in
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
        let db = Firestore.firestore()
        db.collection("Users").document(UserLocal.UserID!).updateData(["comicHistory": FieldValue.arrayUnion([Comic.id ?? ""])])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Comic.isDownloaded = false
        if loadComicFromRealm(){
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
        likeButton.layer.cornerRadius = 30
        likeButton.clipsToBounds = true
        
        btnDownload.layer.cornerRadius = 30
        btnDownload.clipsToBounds = true
    
        readButton.layer.cornerRadius = 30
        readButton.clipsToBounds = true
        
        
        infView.layer.cornerRadius = 30
        cmtView.layer.cornerRadius = 30

        chap.layer.cornerRadius = 20
        chap.clipsToBounds = true
        
    }
    


}
