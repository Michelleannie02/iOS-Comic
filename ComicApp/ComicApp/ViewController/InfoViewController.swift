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
    
    @IBOutlet weak var chap: UILabel!
    
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
                }
                       
            }
            
            for prefix in result.prefixes {
                self.chap.text = "Chap Mới Nhất: Chap " + String(result.prefixes.count)
                //self.chap.sizeToFit()
                
                
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        upLoad()
        name.text = Comic.name
        //name.sizeToFit()
        
    }
    


}
