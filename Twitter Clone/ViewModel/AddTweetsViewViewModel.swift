//
//  AddTweetsViewViewModel.swift
//  Twitter Clone
//
//  Created by Uladzislau Yatskevich on 3.08.23.
//

import Foundation
import Combine
import Firebase

final class AddTweetsViewViewModel {

    var subscriptions: Set<AnyCancellable> = []

    @Published var id: String?
    @Published var user: TwitterUser?
    @Published var textTweet: String = ""

    func getUserData() {
        guard let user = Auth.auth().currentUser else {return}
        DatabaseManager.shared.collectionUsers(retriev: user)
            .sink { _ in

            } receiveValue: { [weak self] twetterUser in
                self?.user = twetterUser
            }
            .store(in: &subscriptions)
    }
   

    func addTweet(){
        guard let user else {return}
        let tweet = Tweet(author: user, authorID: user.id, textTweet: textTweet, like: 0, likers: [])
        DatabaseManager.shared.collectionTweets(Add: tweet)
            .sink(receiveCompletion: { _ in

            }, receiveValue: { status in
                print(status)
            })
            .store(in: &subscriptions)
    }

}
