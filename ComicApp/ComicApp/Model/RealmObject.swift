//
//  RealmObject.swift
//  ComicApp
//
//  Created by Le Van Anh on 12/19/19.
//  Copyright © 2019 Le Van Anh. All rights reserved.
//

import Foundation
import RealmSwift

class LUser: Object {
    @objc dynamic var name : String? = "Guest"
    @objc dynamic var gender :String? = "Other"
    @objc dynamic var email :String? = "guest@gmail.com"
    @objc dynamic var birthday : String? = "01/01/2000"
    @objc dynamic var avatar : Data? = nil
    @objc dynamic var userID : String? = nil
}
class LComic: Object{
    @objc dynamic var comicName: String? = ""
    @objc dynamic var comicID: String? = ""
    @objc dynamic var comicNChap = 0
    @objc dynamic var comicPoster: Data? = nil
    var listChap =  List<LChap>()
}
class LChap: Object{
    var listImg = List<Data>()
}
