//
//  CreateUserNetwork.swift
//  Twitter Clone
//
//  Created by Uladzislau Yatskevich on 23.07.23.
//

import Foundation
import Combine
import Firebase
import FirebaseAuthCombineSwift


class AuthManager {

    static let shared = AuthManager()

    func createUser(email: String, password: String) -> AnyPublisher<User,Error> {
        Auth.auth().createUser(withEmail: email, password: password)
            .map(\.user)
            .eraseToAnyPublisher()
    }

    func loginUser(email: String, password: String) -> AnyPublisher<User,Error> {
        Auth.auth().signIn(withEmail: email, password: password)
            .map(\.user)
            .eraseToAnyPublisher()
    }

}
