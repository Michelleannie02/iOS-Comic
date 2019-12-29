//
//  ShelfViewController.swift
//  ComicApp
//
//  Created by Le Van Anh on 12/21/19.
//  Copyright © 2019 Le Van Anh. All rights reserved.
//

import UIKit

class ShelfViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{


    @IBOutlet weak var segMenu: UISegmentedControl!
    @IBOutlet weak var tbvShelf: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func reLoad(_ sender: Any) {
        tbvShelf.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return segMenu.selectedSegmentIndex == 0 ? Shelf.listDownload.count : ( segMenu.selectedSegmentIndex == 1 ? Shelf.listHistory.count : Shelf.listLike.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listComic = segMenu.selectedSegmentIndex == 0 ? Shelf.listDownload : ( segMenu.selectedSegmentIndex == 1 ? Shelf.listHistory : Shelf.listLike)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "shelfCell", for: indexPath) as! ShelfTableViewCell
        cell.imgPoster.image = UIImage(data: listComic[indexPath.row].poster!)
        cell.lblComicName.text = listComic[indexPath.row].name!
        cell.lblSub.text = listComic[indexPath.row].finish ? "Total chap: \(String(describing: listComic[indexPath.row].totalChap!))":"Dowloading \(listComic[indexPath.row].Dsize!/1024) Kb /\(listComic[indexPath.row].totalSize!/1024) Kb"
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
