//
//  ProfileStorage.swift
//  FakeNFT
//
//  Created by Дмитрий on 22.09.2024.
//

import Foundation

protocol ProfileStorage: AnyObject {
    func saveProfile(profile: Profile)
    func getProfile() -> Profile?
    func clear()
}

// Пример простого класса, который сохраняет данные из сети
final class ProfileStorageImpl: ProfileStorage {
    
    private var profile: Profile? = nil

    private let syncQueue = DispatchQueue(label: "sync-nft-queue")
    
    func saveProfile(profile: Profile) {
        syncQueue.async {
            self.profile = profile
        }
    }
    
    func getProfile() -> Profile? {
        syncQueue.sync {
            profile
        }
    }
    
    func clear() {
        syncQueue.sync {
            self.profile = nil
        }
    }
}
