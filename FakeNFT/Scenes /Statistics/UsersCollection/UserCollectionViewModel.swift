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
    func toggleLike(for nftID: String, completion: @escaping () -> Void)
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
    
    private var profile: Profile? = nil
    private var likes: [String] = []
    
    init(userNFTs: [String],
         nftService: NftService = NftServiceImpl(networkClient: DefaultNetworkClient(),
                                                 storage: NftStorageImpl()),
         profileService: ProfileService = ProfileServiceImpl(networkClient: DefaultNetworkClient(),
                                                             storage: ProfileStorageImpl())
         
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
        loadProfile { [weak self] result in
            switch result {
            case .success:
                self?.loadNFTsAfterProfile(completion: completion)
            case .failure:
                completion()
            }
        }
    }
    
    func toggleLike(for nftID: String, completion: @escaping () -> Void) {
        guard var profile = profile else { return }
        
        if let index = profile.likes.firstIndex(of: nftID) {
            profile.likes.remove(at: index)
        } else {
            profile.likes.append(nftID)
        }
        
        profileService.sendExamplePutRequest(likes: profile.likes, avatar: profile.avatar, name: profile.name) { [weak self] result in
            switch result {
            case .success(let updatedProfile):
                self?.profile = updatedProfile
            case .failure(let error):
                self?.showErrorAlert?(error.localizedDescription)
            }
            completion()
        }
    }
    
    private func loadNFTsAfterProfile(completion: @escaping () -> Void) {
        if userNFTs.isEmpty {
            completion()
            return
        }
        
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
                        isLiked: self?.profile?.likes.contains(nft.id) ?? false
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
    
    private func loadProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        profileService.loadProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.profile = profile
                print("Profile loaded:", profile)
                completion(.success(profile))
            case .failure(let error):
                print("Failed to load user profile: \(error.localizedDescription)")
                self?.showErrorAlert?(Strings.Error.network)
                completion(.failure(error))
            }
        }
    }
}
