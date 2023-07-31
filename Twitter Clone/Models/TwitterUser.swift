//
//  TwitrerProfileViewModel.swift
//  Twitter Clone
//
//  Created by Uladzislau Yatskevich on 26.07.23.
//

import Foundation
import Combine
import Firebase
import FirebaseAuth

struct TwitterUser:Codable {

    let id: String

    var userName: String = ""
    var displayName: String = ""
    var avatarPath: String = ""
    var userBio: String = ""
    var followersCount: Double = 0
    var followingCount: Double = 0
    var joinDate: Date = Date()
    var isFirstEntry: Bool = true

    init(from user: User) {
        self.id = user.uid
    }

}
