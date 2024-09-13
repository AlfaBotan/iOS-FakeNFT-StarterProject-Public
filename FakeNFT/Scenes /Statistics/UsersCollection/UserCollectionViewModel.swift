//
//  UserCollectionViewModel.swift
//  FakeNFT
//
//  Created by Дмитрий on 09.09.2024.
//

import UIKit
import Kingfisher

protocol UserCollectionViewModelProtocol {
    var nftService: NftService { get }
    var numberOfItems: Int { get }
    var onDataChanged: (() -> Void)? { get set }
    
    func item(at indexPath: IndexPath) -> NFTCellModel?
    func loadNFTs()
}

final class UserCollectionViewModel: UserCollectionViewModelProtocol {
    var nftService: NftService
    
    var numberOfItems: Int {
        return nfts.count
    }
    var onDataChanged: (() -> Void)?
    
    init(nftService: NftService = NftServiceImpl(networkClient: DefaultNetworkClient(),
                                                 storage: NftStorageImpl())) {
        self.nftService = nftService
    }
    
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
//        let mockNFTs = (1...15).map { _ in
//            NFTCellModel(image: UIImage(named:"mockNFT") ?? UIImage(),
//                         rating: 3,
//                         name: "Archie",
//                         cost: 1.78)
//        }
        nftService.loadNfts(page: 1, size: 10) { result in
            switch result {
            case .success(let nfts):
                let mockNFTS = nfts.map { nft in
                    NFTCellModel(image: UIImage(named: "mockNFT") ?? UIImage(), 
                                 rating: nft.rating,
                                 name: nft.name,
                                 cost: nft.price)
                }
                self.nfts = mockNFTS
            case .failure(let error):
                print("Localized Description: \(error.localizedDescription)")
                if let error = error as? NSError {
                    print("Domain: \(error.domain)")
                    print("Code: \(error.code)")
                    print("User Info: \(error.userInfo)")
                }
            }
        }
        
    }
}
