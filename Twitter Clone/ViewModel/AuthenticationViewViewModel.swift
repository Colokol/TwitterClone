//
//  RegistrationViewViewModel.swift
//  Twitter Clone
//
//  Created by Uladzislau Yatskevich on 22.07.23.
//

import Foundation
import Firebase
import Combine

final class AuthenticationViewViewModel: ObservableObject {

    private var subscription: Set<AnyCancellable> = []

    @Published var email: String?
    @Published var password: String?
    @Published var isAuthenticationFormValid: Bool = false
    @Published var user: User?
    @Published var error: String?

    func validateAuthenticationForm() {
        guard let email = email ,
              let password = password else {
            isAuthenticationFormValid = false
            return
        }
        isAuthenticationFormValid = isValidEmail(email: email) && password.count >= 8
    }

    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    func createUser() {
        guard let email = email, let password = password else {return}
        AuthManager.shared.createUser(email: email, password: password)
            .handleEvents(receiveOutput: { [weak self] user in
                self?.user = user
            })
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.createRecord(for: user)
            }
            .store(in: &subscription)
    }

    func loginUser() {
        guard let email = email, let password = password else {return}
        AuthManager.shared.loginUser(email: email, password: password)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &subscription)
    }

    func createRecord(for user: User) {
        DatabaseManager.shared.collectionUsers(add: user)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { state in
                print(state)
            }
            .store(in: &subscription)

    }

}
