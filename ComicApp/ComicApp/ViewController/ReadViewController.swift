//
//  ReadViewController.swift
//  ComicApp
//
//  Created by KiD on 12/11/19.
//  Copyright © 2019 Le Van Anh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage


class ReadViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var mySearch: UISearchBar!
    
    @IBOutlet var tap: UITapGestureRecognizer!
    
    @IBAction func tapToHideKeyboard(_ sender: UITapGestureRecognizer) {
           self.mySearch.resignFirstResponder()
       }
       
       func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
           searchBar.endEditing(true)
           searchQuery = mySearch.text!
           tap.isEnabled = false
           
           images = [UIImage]()
           names = [String] ()
        
           self.collectionView.reloadData()
           self.viewDidLoad()
       }
       
       func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
           self.tap.isEnabled = true
       }
       
       func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
           self.tap.isEnabled = false
       }
    
    
    var images = [UIImage]()
    var names = [String] ()
    var searchQuery = ""

    func downImg() {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("Comic")
        
        storageRef.listAll { (result, error) in
            if error != nil {
            return
          }
          for prefix in result.prefixes {
            // The prefixes under storageReference.
            // You may call listAll(completion:) recursively on them.
            if (self.searchQuery == "" || prefix.name.lowercased().contains(self.searchQuery.lowercased())) {
            
            prefix.listAll {( res, err) in
            if err != nil {
                
            }
            for item in res.items {
            // The items under storageReference.
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                item.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if error != nil {
                // Uh-oh, an error occurred!
                        return
                    }
                    
                    let image = UIImage(data: data!)
                    self.images.append(image!)
                    self.names.append(prefix.name)
                    
                    self.collectionView.reloadData()
                    
                }
            }
            }
            }
          }
          for item in result.items {
            // The items under storageReference.
            
            }
        
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.names.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell( withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! CollectionViewCell

        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.label.text = self.names[indexPath.item]
        //cell.label.adjustsFontSizeToFitWidth = true
        cell.label.sizeToFit()
        //cell.label.invalidateIntrinsicContentSize()
        
        cell.imgView.image = self.images[indexPath.item]
        cell.imgView.contentMode = .scaleAspectFit
        let width = UIScreen.main.bounds.width/2 - 2
        let height = width * 1.3
        cell.imgView.frame = CGRect(x: 0,y: 0,width: width, height: height)
        cell.contentView.addSubview(cell.imgView)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        //print("You selected cell #\(indexPath.item)!")
        Comic.name = self.names[indexPath.item]
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        downImg()
        let width = UIScreen.main.bounds.width/2 - 2
        let height = width * 1.5
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: width, height: height)

        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        tap.isEnabled = false
        collectionView.collectionViewLayout = layout
        // Do any additional setup after loading the view.
        
    }

}
