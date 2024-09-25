//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Дмитрий on 20.09.2024.
//

import Foundation

typealias ProfileCompletion = (Result<Profile, Error>) -> Void
typealias ProfilePutCompletion = (Result<Profile, Error>) -> Void

protocol ProfileService {
    func loadProfile(completion: @escaping ProfileCompletion)
    func sendExamplePutRequest(
        likes: [String],
        avatar: String,
        name: String,
        completion: @escaping ProfilePutCompletion
    )
}

final class ProfileServiceImpl: ProfileService {
    private let networkClient: NetworkClient
    private let storage: ProfileStorage
    
    init(networkClient: NetworkClient, storage: ProfileStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }
    
    func loadProfile(completion: @escaping ProfileCompletion) {
        
        //if let profile = storage.getProfile() {
            //completion(.success(profile))
            //return
        //}
        
        let request = ProfileRequest()
        networkClient.send(request: request, type: Profile.self) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.storage.saveProfile(profile: profile)
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func sendExamplePutRequest(likes: [String],
                               avatar: String,
                               name: String,
                               completion: @escaping ProfilePutCompletion) {
        let dto = ProfileDtoObject(likes: likes, avatar: avatar, name: name)
        let request = ProfilePutRequest(dto: dto)
        networkClient.send(request: request, type: Profile.self) { [weak self] result in
            switch result {
            case .success(let profileResponse):
                self?.storage.saveProfile(profile: profileResponse)
                completion(.success(profileResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
