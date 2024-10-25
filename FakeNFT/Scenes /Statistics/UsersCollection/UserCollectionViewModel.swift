//
//  UserCollectionViewModel.swift
//  FakeNFT
//
//  Created by Дмитрий on 09.09.2024.
//

import Foundation

protocol UserCollectionViewModelProtocol {
    var nftService: NftService { get }
    var profileService: ProfileService { get }
    var orderService: OrderService { get }
    var userNFTs: [String] { get }
    var numberOfItems: Int { get }
    var profile: Profile? { get }
    var order: Order? { get }
    var onDataChanged: (() -> Void)? { get set }
    var showErrorAlert: ((String) -> Void)? { get set }
    
    func item(at indexPath: IndexPath) -> NFTCellModel?
    func loadNFTs(isRefreshing: Bool, completion: @escaping () -> Void)
    func toggleLike(for nftId: String, completion: @escaping () -> Void)
    func toggleCart(for nftId: String, completion: @escaping () -> Void)
}

final class UserCollectionViewModel: UserCollectionViewModelProtocol {
    
    private(set) var nftService: NftService
    private(set) var profileService: ProfileService
    private(set) var orderService: OrderService
    
    var userNFTs: [String]
    
    var numberOfItems: Int {
        return nfts.count
    }
    var onDataChanged: (() -> Void)?
    var showErrorAlert: ((String) -> Void)?
    
    private(set) var profile: Profile? = nil
    private(set) var order: Order? = nil
    
    init(userNFTs: [String],
         nftService: NftService = NftServiceImpl(networkClient: DefaultNetworkClient(),
                                                 storage: NftStorageImpl()),
         profileService: ProfileService = ProfileServiceImpl(networkClient: DefaultNetworkClient(),
                                                             storage: ProfileStorageImpl()),
         orderService: OrderService = OrderServiceImpl(networkClient: DefaultNetworkClient())
         
    ) {
        self.userNFTs = userNFTs
        self.nftService = nftService
        self.profileService = profileService
        self.orderService = orderService
    }
    
    private var nfts: [NFTCellModel] = []
    
    func item(at indexPath: IndexPath) -> NFTCellModel? {
        guard indexPath.row < nfts.count else { return nil }
        return nfts[indexPath.row]
    }
    
    func loadNFTs(isRefreshing: Bool, completion: @escaping () -> Void) {
        
        if isRefreshing {
            profileService.clearStorage()
            order = nil
            profile = nil
        }
        
        guard !userNFTs.isEmpty else {
            completion()
            return
        }
        
        loadProfile { [weak self] result in
            switch result {
            case .success:
                self?.loadOrder { [weak self] orderResult in
                    switch orderResult {
                    case .success:
                        self?.loadNFTsAfterProfile(completion: completion)
                    case .failure:
                        completion()
                    }
                }
            case .failure:
                completion()
            }
        }
    }
    
    func toggleLike(for nftId: String, completion: @escaping () -> Void) {
        guard var profile = profile else { return }
        
        if let index = profile.likes.firstIndex(of: nftId) {
            profile.likes.remove(at: index)
        } else {
            profile.likes.append(nftId)
        }
        
        profileService.sendExamplePutRequest(likes: profile.likes, avatar: profile.avatar, name: profile.name) { [weak self] result in
            switch result {
            case .success(let updatedProfile):
                self?.profile = updatedProfile
            case .failure(let error):
                self?.showErrorAlert?(error.localizedDescription)
            }
        }
        
        completion()
    }
    
    func toggleCart(for nftId: String, completion: @escaping () -> Void) {
        guard let order = order else { return }
        var nftsId = order.nfts
        
        if let index = nftsId.firstIndex(of: nftId) {
            nftsId.remove(at: index)
        } else {
            nftsId.append(nftId)
        }
        
        orderService.updateOrder(nftsIds: nftsId) { [weak self] result in
            switch result {
            case .success(let order):
                self?.order = order
            case .failure(let error):
                self?.showErrorAlert?(error.localizedDescription)
            }
        }
        
        completion()
    }
    
    private func loadNFTsAfterProfile(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        var nftsFromNetwork: [NFTCellModel] = []
        
        for userNFT in userNFTs {
            dispatchGroup.enter()
            nftService.loadNft(id: userNFT) { [weak self] result in
                switch result {
                case .success(let nft):
                    let nftCellModel = NFTCellModel(
                        id: nft.id,
                        imageURL: nft.images[0],
                        rating: nft.rating,
                        name: nft.name.components(separatedBy: " ")[0],
                        cost: nft.price,
                        isLiked: self?.profile?.likes.contains(nft.id) ?? false,
                        inCart: self?.order?.nfts.contains(nft.id) ?? false
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
            self.nfts = nftsFromNetwork.sorted { $0.id < $1.id }
            if !self.nfts.isEmpty {
                self.onDataChanged?()
            } else {
                print("No NFTs loaded.")
            }
            completion()
        }
    }
    
    private func loadProfile(completion: @escaping ProfileCompletion) {
        profileService.loadProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.profile = profile
                completion(.success(profile))
            case .failure(let error):
                print("Failed to load user profile: \(error.localizedDescription)")
                completion(.failure(error))
                self?.showErrorAlert?(Strings.Error.network)
            }
        }
    }
    
    private func loadOrder(completion: @escaping OrderCompletion) {
        orderService.loadOrder { [weak self] result in
            switch result {
            case .success(let order):
                self?.order = order
                completion(.success(order))
            case .failure(let error):
                print("Failed to load order: \(error.localizedDescription)")
                completion(.failure(error))
                self?.showErrorAlert?(Strings.Error.network)
            }
        }
    }
}
