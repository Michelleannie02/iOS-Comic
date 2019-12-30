//
//  commentTableViewCell.swift
//  ComicApp
//
//  Created by Le Van Anh on 12/30/19.
//  Copyright © 2019 Le Van Anh. All rights reserved.
//

import UIKit

class commentTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvatarUser: UIImageView!
    @IBOutlet weak var lblUserAndComic: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
