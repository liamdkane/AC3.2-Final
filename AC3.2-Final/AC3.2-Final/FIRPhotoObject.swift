//
//  FIRPhotoObject.swift
//  AC3.2-Final
//
//  Created by C4Q on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation


class FIRPhotoObject {
    let key: String
    let userID: String
    let comment: String
    
    init(key: String, userID: String, comment: String) {
        self.key = key
        self.userID = userID
        self.comment = comment
    }
    var asDictionary: [String: String] {
        let photoDict = [
            "comment" : comment,
            "userID" : userID
        ]
        return photoDict
    }
}
