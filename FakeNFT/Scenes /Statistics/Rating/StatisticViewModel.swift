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
    var users: [UserStatistics] { get }
    
    func loadMockData()
    func sortByName()
    func sortByRating()
    func showSortOptions()
}

final class StatisticViewModel: StatisticViewModelProtocol {
    var reloadTableView: (() -> Void)?
    
    var showSortActionSheet: (() -> Void)?
    
    private(set) var users: [UserStatistics] = []
    
    private var isSortByRating: Bool {
        // TODO: нужно будет разобраться: раз в несколько запусков сохранение порядка не срабатывает(
        
        get {
            let value = UserDefaults.standard.bool(forKey: Constants.UserDefaultKeys.isSortByRating)
            return value
        }
        
        set(newValue) {
            UserDefaults.standard.setValue(newValue,
                                           forKey: Constants.UserDefaultKeys.isSortByRating)
        }
    }
    
    init() {
        loadMockData()
    }
    
    func loadMockData() {
        users = UserMock.mockStatisticsUserData
        
        if isSortByRating {
            sortByRating()
        } else {
            sortByName()
        }
    }
    
    func sortByName() {
        isSortByRating = false
        users.sort { $0.name < $1.name }
        reloadTableView?()
    }
    
    func sortByRating() {
        isSortByRating = true
        users.sort { $0.score > $1.score }
        reloadTableView?()
    }
    
    func showSortOptions() {
        showSortActionSheet?()
    }
}

private enum Constants {
    enum UserDefaultKeys {
        static let isSortByRating = "isSortByRating"
    }
}
