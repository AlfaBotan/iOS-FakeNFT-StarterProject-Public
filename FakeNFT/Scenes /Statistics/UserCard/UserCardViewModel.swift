//
//  UserCardViewModel.swift
//  FakeNFT
//
//  Created by Дмитрий on 09.09.2024.
//

import UIKit

protocol UserCardViewModelProtocol {
    var user: UserStatistics { get }
    var didTapCollectionButton: (() -> Void)? { get set }
    
    func tapCollectionButton()
}

final class UserCardViewModel: UserCardViewModelProtocol {
    var user: UserStatistics
    
    var didTapCollectionButton: (() -> Void)?
    
    init(user: UserStatistics) {
        self.user = user
    }
    
    func tapCollectionButton() {
        didTapCollectionButton?()
    }
}
