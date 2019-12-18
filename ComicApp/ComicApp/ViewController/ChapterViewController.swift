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

    @IBOutlet weak var toolChap: UIToolbar!
    

    @IBOutlet weak var prevButton: UIBarButtonItem!
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    @IBAction func tapToShowTools(_ sender: UITapGestureRecognizer) {
        toolChap.isHidden = !toolChap.isHidden
    }
    
    
    @IBOutlet weak var chap: UINavigationItem!
    
    var images = [UIImage]()
    
    @IBOutlet weak var read: UIScrollView!
    
    @IBAction func prevChap(_ sender: Any) {
        Comic.chap = Comic.chap! - 1
        self.viewDidLoad()
        
    }
    
    @IBAction func nextChap(_ sender: Any) {
        Comic.chap = Comic.chap! + 1
        self.viewDidLoad()
    }
    
    func downLoad(_ index: Int) {
        var path = ""
        if index < 9 {
            path = "/00\(index + 1)"
        } else if index < 99 {
            path = "/0\(index + 1)"
        } else {
            path = "/\(index + 1)"
        }
        
        let storage = Storage.storage()
        let storageRef = storage.reference().child("Comic/" + Comic.name! + path)
        
        
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
    
    func Init() {
        prevButton.isEnabled = true
        nextButton.isEnabled = true
        
        print(Comic.chap!)
        print(Comic.nchap!)
        
        if Comic.chap! <= 0 {
            prevButton.isEnabled = false
        }
        if Comic.chap! >= Comic.nchap! - 1 {
            nextButton.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Init()
        chap.title = "Chap \(Comic.chap! + 1)"
        downLoad(Comic.chap!)
        toolChap.isHidden = true;
    }
    
    override func viewDidLayoutSubviews() {
//        viewDidLoad()
    }

}
