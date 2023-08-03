//
//  Tweet.swift
//  Twitter Clone
//
//  Created by Uladzislau Yatskevich on 3.08.23.
//

import Foundation
import Firebase

struct Tweet: Codable {

    var id = UUID().uuidString
    let author: TwitterUser
    let authorID:String
    let textTweet: String
    let like: Int
    let likers:[String]

}

