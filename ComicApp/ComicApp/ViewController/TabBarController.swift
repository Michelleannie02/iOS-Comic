//
//  TabBarController.swift
//  ComicApp
//
//  Created by Le Van Anh on 12/10/19.
//  Copyright © 2019 Le Van Anh. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    @IBInspectable var defaultIndex: Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
        selectedIndex = Utilities.defaultIndex
 */
        selectedIndex = defaultIndex
        UserLocal.downAccount()
        Shelf.ComicRealmToRam()
        Shelf.DownloadList()
        Comment.dowloadListReviewWorld()
    }
    
}
