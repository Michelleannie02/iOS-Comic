//
//  Comment.swift
//  ComicApp
//
//  Created by Le Van Anh on 12/30/19.
//  Copyright © 2019 Le Van Anh. All rights reserved.
//

import Foundation
import Firebase


class Comment{
    static var listReviewWorld: [String] = []
    static var listCommentComic: [String] = []
    static func dowloadListReviewWorld(){
        let db = Firestore.firestore()
        db.collection("Comment").document("listCommentID").getDocument { (document, error) in
            if error == nil{
                listReviewWorld = (document?.data()?["listComment"] as? Array<String>)!
            }
        }
    }
    static func downloadListCommentComic(_ id: String){
        let db = Firestore.firestore()
        db.collection("Comic").document(id).getDocument { (document, error) in
            if error == nil{
                listCommentComic = (document?.data()?["comment"] as? Array<String>)!
            }
        }
    }
}

class LComment: NSObject{
    var idComment: String? = ""
    var idComic: String? = ""
    var idUser: String? = ""
    var content: String? = ""
}
