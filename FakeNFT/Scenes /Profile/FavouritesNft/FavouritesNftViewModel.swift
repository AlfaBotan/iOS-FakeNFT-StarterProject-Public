import Foundation

final class FavouritesNftViewModel {
    
    private let nftDataKey = "favouritesNftDataKey"
    private let nftService: NftService = NftServiceImpl(networkClient: DefaultNetworkClient(), storage: NftStorageImpl())
    private let profileService: ProfileService = ProfileServiceImpl(networkClient: DefaultNetworkClient(), storage: ProfileStorageImpl())
    
    var onDataChanged: (() -> Void)?
    
    // Массив данных NFT
    var nftData: [Nft] = []
    var profile: Profile?
    var nftList: [String]
    
    init(nftList: [String], profile: Profile?) {
        self.nftList = nftList
        self.profile = profile
    }
    
    // Функция для получения данных
    func getNftData() -> [Nft] {
        return nftData
    }
    
    func loadNFT() {
        let dispatchGroup = DispatchGroup()
        var nftsFromNetwork: [Nft] = []
        
        for myNFT in nftList {
            dispatchGroup.enter()
            nftService.loadNft(id: myNFT) { result in
                switch result {
                case .success(let nft):
                    nftsFromNetwork.append(nft)
                case .failure(let error):
                    print("Failed to load NFT with id \(myNFT): \(error.localizedDescription)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.nftData = nftsFromNetwork
            print(self.nftData)
            self.onDataChanged?()
        }
    }
    
    func removeFromFavourites(nftId: String) {
        if let index = nftData.firstIndex(where: { $0.id == nftId }) {
            nftData.remove(at: index)
            onDataChanged?()
        }
    }

    func toggleLike(for nftId: String, completion: @escaping () -> Void) {
        guard let profile = profile else { return }
        if let index = nftList.firstIndex(of: nftId) {
            nftList.remove(at: index)
            removeFromFavourites(nftId: nftId)
        }
        profileService.sendExamplePutRequest(likes: nftList, avatar: profile.avatar, name: profile.name) { [weak self] result in
            switch result {
            case .success(let updatedProfile):
                self?.profile = updatedProfile
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
            completion()
        }
    }
}
