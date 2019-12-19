//
//  ShowChapViewController.swift
//  ComicApp
//
//  Created by KiD on 12/18/19.
//  Copyright © 2019 Le Van Anh. All rights reserved.
//

import UIKit

class ShowChapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

        // Data model: These strings will be the data for the table view cells
    var chap = [Int]()
    
    func Init() {
        chap = [Int]()
        if Comic.nchap! < 1 {
            return
        }
        for i in 1...Comic.nchap! {
            chap.append(Comic.nchap! - i + 1)
        }
    }
        // don't forget to hook this up from the storyboard
        @IBOutlet var tableView: UITableView!

        override func viewDidLoad() {
            super.viewDidLoad()
            
            Init()
            
            // Register the table view cell class and its reuse id
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "chap")

            // (optional) include this line if you want to remove the extra empty cell divider lines
            // self.tableView.tableFooterView = UIView()

            // This view controller itself will provide the delegate methods and row data for the table view.
            tableView.delegate = self
            tableView.dataSource = self
        }

        // number of rows in table view
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.chap.count
        }

        // create a cell for each table view row
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            // create a new cell if needed or reuse an old one
            let cell:UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "chap") as UITableViewCell?)!

            // set the text from the data model
            cell.textLabel?.text = "Chap \(self.chap[indexPath.row])"
            cell.textLabel?.textAlignment = .center
            return cell
        }
        

        // method to run when table view cell is tapped
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            Comic.chap = Comic.nchap! - indexPath.row - 1
            performSegue(withIdentifier: "showChap", sender: self)
        }
   
    }
