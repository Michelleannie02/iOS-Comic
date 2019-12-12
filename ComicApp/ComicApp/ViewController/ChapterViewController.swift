//
//  ChapterViewController.swift
//  ComicApp
//
//  Created by KiD on 12/11/19.
//  Copyright © 2019 Le Van Anh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class ChapterViewController: UIViewController {

    var images = [UIImage]()
    
    @IBOutlet weak var read: UIScrollView!
    
    func downLoad() {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("Comic/" + Comic.name! + "/001")
        
        
        storageRef.listAll { (result, err) in
                   if err != nil {
                       // Uh-oh, an error occurred!
                       print("Err")
                       return
                   } else {
                       var height = CGFloat(0)
                       //for i in result.items {print(i.name)}
                       
                       for item in result.items {
                           // The items under storageReference.
                           // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                           
                           //print(item.fullPath)
                           
                           item.getData(maxSize: 1 * 1024 * 1024) { data, error in
                               if error != nil {
                                   // Uh-oh, an error occurred!
                                   return
                               } else {
                                   // Data for "images/island.jpg" is returned
                                   
                                   
                                                     
                                   //group.notify(queue: DispatchQueue.main)
                                   let image = UIImage(data: data!)
                                 
                                   self.images.append(image!)
                                   
                                   //print(item.name)
                                   
                                   
                                       
                                   let imageView = UIImageView()
                                   
                                   let widthScale = self.read.bounds.width /  image!.size.width
                                   
                                   imageView.frame = CGRect(x: 0, y: height, width: self.view.frame.width, height: image!.size.height * CGFloat(widthScale))
                                   height += image!.size.height * CGFloat(widthScale)
                                   
                                   imageView.contentMode = .scaleAspectFit
                                   imageView.image = image
                                   
                                   self.read.contentSize.height = height + 0
                                   self.read.addSubview(imageView)
                                   
                               }
                       
                           }
                           
                       }
                   }
               }

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        viewDidLoad()
    }

}
