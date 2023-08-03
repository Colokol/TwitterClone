    //
    //  ProfileDataFormViewModel.swift
    //  Twitter Clone
    //
    //  Created by Uladzislau Yatskevich on 26.07.23.
    //

import Foundation
import Combine
import Firebase
import FirebaseStorage
import FirebaseAuth

final class ProfileDataFormViewModel: ObservableObject {

    var subscriptions: Set<AnyCancellable> = []

    @Published var username: String?
    @Published var displayName: String?
    @Published var avatarPath: String?
    @Published var userBio: String?
    @Published var user: User?
    @Published var imageData: UIImage?
    @Published var isAuthenticationFormValid: Bool = false
    @Published var isFirstEntry: Bool = true
    @Published var error: String?
    @Published var twitterUser: TwitterUser?
    @Published var joinDate: Date?
    @Published var isOnboardingFinished: Bool = false

    func vereficationName() {
        guard let displayName, let username else {return}
        self.isAuthenticationFormValid = displayName.count > 2 && username.count > 2
    }

    func uploadAvatar(){
        guard let imageData = imageData?.jpegData(compressionQuality: 0.5) else {return}
        let randomId = UUID().uuidString
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        StorageManager.shared.uploadAvatar(with: randomId, data: imageData, metaData: metadata)
            .flatMap({ storageMetadata in
                StorageManager.shared.downloadImageURL(with: metadata.path)
            })
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] url  in
                self?.avatarPath = url.absoluteString
            }
            .store(in: &subscriptions)
    }

    func setData() {
        guard let user = Auth.auth().currentUser else {return}
        guard let username, let displayName, let avatarPath, let userBio else {return} // is this line needed?
        let data:[String:Any] = [
            "username": username,
            "displayName": displayName,
            "avatarPath": avatarPath,
            "userBio": userBio,
            "isFirstEntry": !self.isFirstEntry
        ]
        DatabaseManager.shared.collectionUsers(UpdateData: data, user: user)
            .sink { error in
            } receiveValue: {[weak self] status in
                self?.isOnboardingFinished = status
            }
            .store(in: &subscriptions)
    }

    func loadDataUser(){
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

}
