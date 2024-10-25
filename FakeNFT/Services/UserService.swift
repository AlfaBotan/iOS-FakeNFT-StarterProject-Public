//
//  UserService.swift
//  FakeNFT
//
//  Created by Дмитрий on 21.09.2024.
//

import Foundation

typealias UsersCompletion = (Result<Users, Error>) -> Void

protocol UserService {
    func loadUsers(page: Int, size: Int, completion: @escaping UsersCompletion)
    func loadNextUsersPage(completion: @escaping UsersCompletion)
    func resetPagination()
}

final class UserServiceImpl: UserService {
    
    private let networkClient: NetworkClient
    private let storage: UserStorage
    
    private(set) var users: Users = []
    private var lastLoadedPage: Int?
    private var isFetching = false
    
    init(networkClient: NetworkClient, storage: UserStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }
    
    func resetPagination() {
        lastLoadedPage = nil
        users.removeAll()
    }
    
    func loadUsers(page: Int, size: Int, completion: @escaping UsersCompletion) {
        
        if page == 0 {
            storage.clearUsers()
        }
        
        if let user = storage.getUsers(with: page) {
            completion(.success(user))
            return
        }
        
        let request = UsersRequest(page: page, size: size)
        networkClient.send(request: request, type: Users.self) { [weak self] result in
            switch result {
            case .success(let users):
                self?.lastLoadedPage = page
                self?.storage.saveUsers(users, page: page)
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadNextUsersPage(completion: @escaping UsersCompletion) {
        guard !isFetching else { return }
        
        let nextPage = (lastLoadedPage ?? -1) + 1
        
        isFetching = true
        loadUsers(page: nextPage, size: 10) { [weak self] result in
            switch result {
            case .success(let users):
                self?.users += users
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
            
            self?.isFetching = false
        }
    }
}
