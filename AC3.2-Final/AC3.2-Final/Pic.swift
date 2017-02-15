//
//  Pic.swift
//  AC3.2-Final
//
//  Created by Victor Zhong on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

class Pic {
    let key: String
    let user: String
    let comment: String
    
    init(key: String,
         user: String,
         comment: String) {
        self.key = key
        self.user = user
        self.comment = comment
    }
    
    var asDictionary: [String:String] {
        return ["key": key, "url": user, "comment": comment]
    }
}
