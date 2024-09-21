//
//  UserStorage.swift
//  FakeNFT
//
//  Created by Дмитрий on 21.09.2024.
//

import Foundation

protocol UserStorage: AnyObject {
    func saveUsers(_ user: Users, page: Int)
    func getUsers(with page: Int) -> Users?
}

final class UserStorageImpl: UserStorage {
    
    private var userArray: [Int: Users] = [:]
    private var lastLoadedPage: Int = 0
    
    private let syncQueue = DispatchQueue(label: "sync-user-queue")
    
    func saveUsers(_ userArray: Users, page: Int) {
        syncQueue.async { [weak self] in
            guard let self = self else { return }
            self.userArray[page] = userArray
        }
    }
    
    func getUsers(with page: Int) -> Users? {
        syncQueue.sync {
            userArray[page]
        }
    }
}
