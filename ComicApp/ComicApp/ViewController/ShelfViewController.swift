//
//  ShelfViewController.swift
//  ComicApp
//
//  Created by Le Van Anh on 12/21/19.
//  Copyright © 2019 Le Van Anh. All rights reserved.
//

import UIKit
import Firebase

class ShelfViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{


    @IBOutlet weak var segMenu: UISegmentedControl!
    @IBOutlet weak var tbvShelf: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func reLoad(_ sender: Any) {
        tbvShelf.reloadData()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        tbvShelf.reloadData()
        if segMenu.selectedSegmentIndex == 0 && Comic.isDowloading > 0{
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return segMenu.selectedSegmentIndex == 0 ? Shelf.listDownload.count : ( segMenu.selectedSegmentIndex == 1 ? Shelf.listHistory.count : Shelf.listLike.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listComic = segMenu.selectedSegmentIndex == 0 ? Shelf.listDownload : ( segMenu.selectedSegmentIndex == 1 ? Shelf.listHistory : Shelf.listLike)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "shelfCell", for: indexPath) as! ShelfTableViewCell
        cell.imgPoster.image = UIImage(data: listComic[indexPath.row].poster!)
        cell.lblComicName.text = listComic[indexPath.row].name!
        if !listComic[indexPath.row].finish {
            if listComic[indexPath.row].Dsize! > listComic[indexPath.row].totalSize!{
                cell.lblSub.text = "Dowloading \(Utilities.fixTypeSize(listComic[indexPath.row].totalSize!)) Kb"
            }
            else{
                cell.lblSub.text = "Dowloading \(Utilities.fixTypeSize(listComic[indexPath.row].Dsize!)) /\(Utilities.fixTypeSize(listComic[indexPath.row].totalSize!))"
            }
        }
        else{
            cell.lblSub.text = "Total chap: \(String(describing: listComic[indexPath.row].totalChap!))"
        }
        cell.avdDownload.isHidden = listComic[indexPath.row].finish
        cell.btnCancel.isHidden = listComic[indexPath.row].finish
        if segMenu.selectedSegmentIndex == 0 {
            cell.avdDownload.setProgress(Float(listComic[indexPath.row].Dsize!) / Float(listComic[indexPath.row].totalSize!), animated: false)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listComic = segMenu.selectedSegmentIndex == 0 ? Shelf.listDownload : ( segMenu.selectedSegmentIndex == 1 ? Shelf.listHistory : Shelf.listLike)
        Comic.id = listComic[indexPath.row].idComic
        performSegue(withIdentifier: "showInfo", sender: self)
    }
}
