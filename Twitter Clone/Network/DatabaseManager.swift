//
//  DataManager.swift
//  Twitter Clone
//
//  Created by Uladzislau Yatskevich on 26.07.23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift
import Combine

final class DatabaseManager {

    static let shared = DatabaseManager()

    let db = Firestore.firestore()
    let userPath: String = "Users"
    let tweetsPath: String = "Tweets"

    func collectionUsers(add user: User) -> AnyPublisher<Bool,Error> {
        let twitterUser = TwitterUser(from: user)
        return  db.collection(userPath).document(twitterUser.id).setData(from: twitterUser)
            .map { _ in
                return true
            }
            .eraseToAnyPublisher()
    }

    func collectionUsers(retriev user: User) -> AnyPublisher<TwitterUser,Error> {
        let twitterUser = TwitterUser(from: user)
        return db.collection(userPath).document(twitterUser.id).getDocument()
            .tryMap({
            try $0.data(as: TwitterUser.self)
            })
            .eraseToAnyPublisher()
    }

    func collectionUsers(UpdateData data:[String:Any], user:User) -> AnyPublisher<Bool,Error> {

        return db.collection(userPath).document(user.uid).updateData(data)
            .map({ _ in
                return true
            })
            .eraseToAnyPublisher()
    }

    func collectionTweets(Add tweets:Tweet) -> AnyPublisher<Bool,Error> {
        return db.collection(tweetsPath).document(tweets.id).setData(from: tweets)
            .map { _ in
                return true
            }
            .eraseToAnyPublisher()
    }

    func collectionTweets(retriev userID: String) -> AnyPublisher<[Tweet],Error> {
        return db.collection(tweetsPath).whereField("authorID", isEqualTo: userID).getDocuments()
            .tryMap(\.documents)
            .tryMap { snapshot in
               try snapshot.map { oneSnapshot in
                   try oneSnapshot.data(as:Tweet.self)
                }
            }
            .eraseToAnyPublisher()
    }


}

