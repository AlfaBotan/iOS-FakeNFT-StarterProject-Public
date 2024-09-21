//
//  StatisticViewModel.swift
//  FakeNFT
//
//  Created by Дмитрий on 06.09.2024.
//

import Foundation

protocol StatisticViewModelProtocol: AnyObject {
    var reloadTableView: (() -> Void)? { get set }
    var showSortActionSheet: (() -> Void)? { get set }
    var users: Users { get }
    var isLoadingData: Bool { get }
    
    func loadData(completion: @escaping () -> Void)
    func sortByName()
    func sortByRating()
    func showSortOptions()
}

final class StatisticViewModel: StatisticViewModelProtocol {
    var reloadTableView: (() -> Void)?
    var showSortActionSheet: (() -> Void)?
    
    private(set) var isLoadingData = false
    private(set) var users: Users = []
    private let userService: UserService
    
    private var isSortByName: Bool {
        // TODO: нужно будет разобраться: раз в несколько запусков сохранение порядка не срабатывает(
        
        get {
            let value = UserDefaults.standard.bool(forKey: Constants.UserDefaultKeys.isSortByName)
            return value
        }
        
        set(newValue) {
            UserDefaults.standard.setValue(newValue,
                                           forKey: Constants.UserDefaultKeys.isSortByName)
        }
    }
    
    init(userService: UserService = UserServiceImpl(
        networkClient: DefaultNetworkClient(), storage: UserStorageImpl())
    ) {
        self.userService = userService
    }
    
    func loadData(completion: @escaping () -> Void) {
        
        guard !isLoadingData else { return }
        
        isLoadingData = true
        userService.loadNextUsersPage { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let users):
                
                self.users += users
                
                if self.isSortByName {
                    self.sortByName()
                } else {
                    self.sortByRating()
                }
                
                completion()
            case .failure(let error):
                // TODO: Добавить алерт
                print("[StatisticViewModel]: \(error.localizedDescription)")
                completion()
            }
            
            self.isLoadingData = false
        }
    }
    
    func sortByName() {
        isSortByName = true
        users.sort { $0.name < $1.name }
        reloadTableView?()
    }
    
    func sortByRating() {
        isSortByName = false
        users.sort { $0.rating > $1.rating }
        reloadTableView?()
    }
    
    func showSortOptions() {
        showSortActionSheet?()
    }
}

private enum Constants {
    enum UserDefaultKeys {
        static let isSortByName = "isSortByName"
    }
}
