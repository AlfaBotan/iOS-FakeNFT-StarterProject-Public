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
    var hasMoreData: Bool { get }
    
    func loadData(completion: @escaping () -> Void)
    func sortByName()
    func sortByRating()
    func showSortOptions()
    func resetPagination()
}

final class StatisticViewModel: StatisticViewModelProtocol {
    var reloadTableView: (() -> Void)?
    var showSortActionSheet: (() -> Void)?
    
    private(set) var isLoadingData = false
    private(set) var users: Users = []
    private(set) var hasMoreData = true
    private let userService: UserService
    
    private var isFirstLoad = true
    
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
    
    func resetPagination() {
        isFirstLoad = true
        hasMoreData = true
        users.removeAll()
        userService.resetPagination()
        reloadTableView?()
    }
    
    func loadData(completion: @escaping () -> Void) {
        
        guard !isLoadingData, hasMoreData else {
            completion()
            return
        }
        
        isLoadingData = true
        userService.loadNextUsersPage { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let users):
                self.users += users 
                self.hasMoreData = !users.isEmpty
                
                if self.isFirstLoad {
                    if self.isSortByName {
                        self.sortByName()
                    } else {
                        self.sortByRating()
                    }
                    self.isFirstLoad = false
                }
                
                completion()
            case .failure(let error):
                // TODO: Добавить алерт
                
                print("[StatisticViewModel]: \(error.localizedDescription)")
                completion()
            }
            
            self.isLoadingData = false
            reloadTableView?()
        }
    }
    
    func sortByName() {
        isSortByName = true
        users.sort { $0.name < $1.name }
    }
    
    func sortByRating() {
        isSortByName = false
        users.sort { $0.rating > $1.rating }
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
