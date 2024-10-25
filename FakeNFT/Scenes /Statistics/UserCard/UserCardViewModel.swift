//
//  UserCardViewModel.swift
//  FakeNFT
//
//  Created by Дмитрий on 09.09.2024.
//

import UIKit

protocol UserCardViewModelProtocol {
    var user: User { get }
    var didTapCollectionButton: (() -> Void)? { get set }
    
    func tapCollectionButton()
}

final class UserCardViewModel: UserCardViewModelProtocol {
    var user: User
    
    var didTapCollectionButton: (() -> Void)?
    
    init(user: User) {
        self.user = user
    }
    
    func tapCollectionButton() {
        didTapCollectionButton?()
    }
}
