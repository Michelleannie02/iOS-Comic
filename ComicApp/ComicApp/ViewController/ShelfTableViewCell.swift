//
//  ShelfTableViewCell.swift
//  ComicApp
//
//  Created by Le Van Anh on 12/21/19.
//  Copyright © 2019 Le Van Anh. All rights reserved.
//

import UIKit

class ShelfTableViewCell: UITableViewCell {

    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var lblComicName: UILabel!
    @IBOutlet weak var avdDownload: UIProgressView!
    @IBOutlet weak var lblSub: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func CancelDownload(_ sender: Any) {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
