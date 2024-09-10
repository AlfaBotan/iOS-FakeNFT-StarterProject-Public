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
    
    init() {
        loadMockData()
    }
    
    func loadMockData() {
        users = UserMock.mockStatisticsUserData
        reloadTableView?()
    }
    
    func sortByName() {
        users.sort { $0.name < $1.name }
        reloadTableView?()
    }
    
    func sortByRating() {
        users.sort { $0.score > $1.score }
        reloadTableView?()
    }
    
    func showSortOptions() {
        showSortActionSheet?()
    }
}
