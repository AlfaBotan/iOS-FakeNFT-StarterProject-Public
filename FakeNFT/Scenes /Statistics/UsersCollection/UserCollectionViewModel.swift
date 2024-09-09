//
//  UserCollectionViewModel.swift
//  FakeNFT
//
//  Created by Дмитрий on 09.09.2024.
//

import UIKit

protocol UserCollectionViewModelProtocol {
    var numberOfItems: Int { get }
    var onDataChanged: (() -> Void)? { get set }
    
    func item(at indexPath: IndexPath) -> NFTCellModel?
    func loadNFTs()
}

final class UserCollectionViewModel: UserCollectionViewModelProtocol {
    var numberOfItems: Int {
        return nfts.count
    }
    var onDataChanged: (() -> Void)?
    
    private var nfts: [NFTCellModel] = [] {
        didSet {
            onDataChanged?()
        }
    }
    
    func item(at indexPath: IndexPath) -> NFTCellModel? {
        guard indexPath.row < nfts.count else { return nil }
        return nfts[indexPath.row]
    }
    
    func loadNFTs() {
        // TODO: Заменить на актуальные данные после создания сервиса
        let mockNFTs = (1...15).map { _ in
            NFTCellModel(image: UIImage(named:"mockNFT") ?? UIImage(),
                         rating: 3,
                         name: "Archie",
                         cost: 1.78)
        }
        nfts = mockNFTs
    }
}
