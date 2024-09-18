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
    
    func loadMockData()
    func sortByName()
    func sortByRating()
    func showSortOptions()
}

final class StatisticViewModel: StatisticViewModelProtocol {
    var reloadTableView: (() -> Void)?
    
    var showSortActionSheet: (() -> Void)?
    
    private(set) var users: Users = []
    
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
    
    init() {
        loadMockData()
    }
    
    func loadMockData() {
        users = UserMock.mockStatisticsUserData
        
        if isSortByName {
            sortByName()
        } else {
            sortByRating()
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
