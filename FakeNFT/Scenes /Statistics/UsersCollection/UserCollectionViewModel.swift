//
//  UserCollectionViewModel.swift
//  FakeNFT
//
//  Created by Дмитрий on 09.09.2024.
//

import Foundation

protocol UserCollectionViewModelProtocol {
    var userNFTs: [String] { get }
    var nftService: NftService { get }
    var profileService: ProfileService { get }
    var numberOfItems: Int { get }
    var onDataChanged: (() -> Void)? { get set }
    var showErrorAlert: ((String) -> Void)? { get set }
    
    func item(at indexPath: IndexPath) -> NFTCellModel?
    func loadNFTs(completion: @escaping () -> Void)
}

final class UserCollectionViewModel: UserCollectionViewModelProtocol {
    
    var nftService: NftService
    var profileService: ProfileService
    var userNFTs: [String]
    
    var numberOfItems: Int {
        return nfts.count
    }
    var onDataChanged: (() -> Void)?
    var showErrorAlert: ((String) -> Void)?
    
    init(userNFTs: [String],
         nftService: NftService = NftServiceImpl(networkClient: DefaultNetworkClient(),
                                                 storage: NftStorageImpl()),
         profileService: ProfileService = ProfileServiceImpl(networkClient: DefaultNetworkClient())
    
    ) {
        self.userNFTs = userNFTs
        self.nftService = nftService
        self.profileService = profileService
    }
    
    private var nfts: [NFTCellModel] = []
    
    func item(at indexPath: IndexPath) -> NFTCellModel? {
        guard indexPath.row < nfts.count else { return nil }
        return nfts[indexPath.row]
    }
    
    func loadNFTs(completion: @escaping () -> Void) {
        if userNFTs.isEmpty {
            completion()
            return
        }
        
        var nftsFromNetwork: [NFTCellModel] = []
        let dispatchGroup = DispatchGroup()
        
        for userNFT in userNFTs {
            dispatchGroup.enter()
            nftService.loadNft(id: userNFT) { [weak self] result in
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
                    self?.showErrorAlert?(Strings.Error.network)
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.nfts = nftsFromNetwork
            if !self.nfts.isEmpty {
                self.onDataChanged?()
            } else {
                print("No NFTs loaded.")
            }
            completion() // Сообщаем о завершении загрузки
        }
    }
}
