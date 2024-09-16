//
//  UserCollectionViewModel.swift
//  FakeNFT
//
//  Created by Дмитрий on 09.09.2024.
//

import UIKit
import ProgressHUD

protocol UserCollectionViewModelProtocol {
    var userNFTs: [String] { get }
    var nftService: NftService { get }
    var numberOfItems: Int { get }
    var onDataChanged: (() -> Void)? { get set }
    
    func item(at indexPath: IndexPath) -> NFTCellModel?
    func loadNFTs()
}

final class UserCollectionViewModel: UserCollectionViewModelProtocol {
    
    var nftService: NftService
    var userNFTs: [String]
    
    var numberOfItems: Int {
        return nfts.count
    }
    var onDataChanged: (() -> Void)?
    
    init(userNFTs: [String],
         nftService: NftService = NftServiceImpl(networkClient: DefaultNetworkClient(),
                                                 storage: NftStorageImpl())) {
        self.userNFTs = userNFTs
        self.nftService = nftService
        print(userNFTs)
    }
    
    private var nfts: [NFTCellModel] = []
    
    func item(at indexPath: IndexPath) -> NFTCellModel? {
        guard indexPath.row < nfts.count else { return nil }
        return nfts[indexPath.row]
    }
    
    func loadNFTs() {
        
        if userNFTs.count == 0 {
            return
        }
        
        ProgressHUD.show()
        var nftsFromNetwork: [NFTCellModel] = []
        let dispatchGroup = DispatchGroup()
        
        for userNFT in userNFTs {
            dispatchGroup.enter()
            nftService.loadNft(id: userNFT) { result in
                switch result {
                case .success(let nft):
                    let nftCellModel = NFTCellModel(
                        imageURL: nft.images[0],
                        rating: nft.rating,
                        name: nft.name.components(separatedBy: " ")[0],
                        cost: nft.price
                    )
                    nftsFromNetwork.append(nftCellModel)
                    
                case .failure(let error):
                    print("Failed to load NFT with id \(userNFT): \(error.localizedDescription)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.nfts = nftsFromNetwork
            if !self.nfts.isEmpty {
                self.onDataChanged?()
            } else {
                // Можно вывести сообщение, что данные не загружены
                print("No NFTs loaded.")
            }
            ProgressHUD.dismiss()
        }
    }
    
}
