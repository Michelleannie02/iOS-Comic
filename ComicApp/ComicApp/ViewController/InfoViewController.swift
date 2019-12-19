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
    
    @IBOutlet weak var chap: UIButton!
    
    func upLoad ()
    {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("Comic/" + Comic.name!)
        
        storageRef.listAll { (result, error) in
            if error != nil {
                return
            }
            // code
            for item in result.items {
                // The items under storageReference.
                item.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if error != nil {
                // Uh-oh, an error occurred!
                        return
                    }
                    
                    let image = UIImage(data: data!)
                    self.imgView.image = image
                    self.imgView.contentMode = .scaleAspectFill
                }
                       
            }
            
            for _ in result.prefixes {
                
                self.chap.setTitle( "Chap Mới Nhất: Chap " + String(result.prefixes.count), for: .normal)
                
                Comic.nchap = result.prefixes.count
                
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        upLoad()
        name.text = Comic.name
        
        likeButton.layer.cornerRadius = 30
        likeButton.clipsToBounds = true
    
        readButton.layer.cornerRadius = 30
        readButton.clipsToBounds = true
        
        
        infView.layer.cornerRadius = 30
        //infView.layer.borderWidth = 2
        //infView.layer.borderColor = UIColor.black.cgColor
        cmtView.layer.cornerRadius = 30

        chap.layer.cornerRadius = 20
        chap.clipsToBounds = true
        
    }
    


}
