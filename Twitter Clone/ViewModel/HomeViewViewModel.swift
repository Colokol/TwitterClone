//
//  HomeViewViewModel.swift
//  Twitter Clone
//
//  Created by Uladzislau Yatskevich on 26.07.23.
//

import Foundation
import Combine
import FirebaseAuth

final class HomeViewViewModel: ObservableObject {

    @Published var twitterUser: TwitterUser?
    @Published var error: String?
    @Published var tweetsArray : [Tweet] = []
    
    var subscriptions: Set<AnyCancellable> = []

    func retrieveUser() {
        guard let user = Auth.auth().currentUser else {return}
        DatabaseManager.shared.collectionUsers(retriev: user)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.twitterUser = user
            }
            .store(in: &subscriptions)
    }

    func retrievTweets(){
        guard let user = Auth.auth().currentUser else {return}

        DatabaseManager.shared.collectionTweets(retriev: user.uid)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] tweets in
                self?.tweetsArray = tweets
            }
            .store(in: &subscriptions)

    }

}
