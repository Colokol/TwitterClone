//
//  StorageManager.swift
//  Twitter Clone
//
//  Created by Uladzislau Yatskevich on 27.07.23.
//

import Foundation
import Combine
import FirebaseStorage
import FirebaseStorageCombineSwift

enum ErrorLoad: Error {
    case downloadError
}

final class StorageManager {

    static let shared = StorageManager()

    let storage = Storage.storage()

    func downloadImageURL(with id: String?) -> AnyPublisher<URL,Error> {
        guard let id = id else {
            return  Fail(error: ErrorLoad.downloadError)
                .eraseToAnyPublisher()
        }
       return storage
            .reference(withPath: id)
            .downloadURL()
            .eraseToAnyPublisher()
    }

    func uploadAvatar(with randomID:String, data:Data, metaData:StorageMetadata) -> AnyPublisher<StorageMetadata,Error> {
        return storage
            .reference()
            .child("images/\(randomID)")
            .putData(data,metadata: metaData)
            .eraseToAnyPublisher()
    }

}
