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
        down()
            
    }
    @IBAction func reLoad(_ sender: Any) {
        down()
        tbvShelf.reloadData()
        print(segMenu.selectedSegmentIndex)
    }
    func down(){
        switch segMenu.selectedSegmentIndex {
        case 0:
            break
        case 1:
            break
        case 2:
            break
        default:
            break
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return segMenu.selectedSegmentIndex + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shelfCell", for: indexPath) as! ShelfTableViewCell
        return cell
    }
    
}
