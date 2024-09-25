import Foundation

final class MyNftViewModel {
    
    var nftData: [Nft] = []
    var onDataChanged: (() -> Void)?
    private let nftService: NftService = NftServiceImpl(networkClient: DefaultNetworkClient(), storage: NftStorageImpl())
    private let profileService: ProfileService = ProfileServiceImpl(networkClient: DefaultNetworkClient(), storage: ProfileStorageImpl())
    
    private let favouritesKey = "favouritesNftKey"
    private let sortKey = "nftSortType"
    
    var profile: Profile?
    var nftList: [String]
    var favouriteList: [String]
    
    init(nftList: [String], favouriteList: [String], profile: Profile?) {
        self.nftList = nftList
        self.favouriteList = favouriteList
        self.profile = profile
    }
    
    // Типы сортировки
    enum SortType: String {
        case name, price, rating
    }
    
    // Данные, которые будут доступны для View
    var filteredNftData: [Nft] {
        return nftData
    }
    
    // Применение сохраненной сортировки при загрузке
    func applySavedSort() {
        let savedSort = UserDefaults.standard.string(forKey: sortKey) ?? SortType.rating.rawValue
        sort(by: SortType(rawValue: savedSort) ?? .rating)
    }
    
    // Метод сортировки по выбранному типу
    func sort(by type: SortType) {
        switch type {
        case .name:
            sortByName()
        case .price:
            sortByPrice()
        case .rating:
            sortByRating()
        }
        // Сохранение выбранного типа сортировки
        UserDefaults.standard.set(type.rawValue, forKey: sortKey)
        onDataChanged?()  // Вызываем, чтобы обновить данные после сортировки
    }
    
    // Сортировка по имени
    private func sortByName() {
        nftData.sort { $0.name < $1.name }
    }
    
    // Сортировка по цене
    private func sortByPrice() {
        nftData.sort { $0.price < $1.price }
    }
    
    // Сортировка по рейтингу
    private func sortByRating() {
        nftData.sort { $0.rating > $1.rating }
    }
    
    // Загрузка данных NFT
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
            self.applySavedSort()  // Применяем сортировку после загрузки данных
            self.onDataChanged?()
        }
    }
    
    // Логика для переключения избранных (лайк/дизлайк)
    func toggleLike(for nftId: String, completion: @escaping () -> Void) {
        guard let profile = profile else { return }
        if let index = favouriteList.firstIndex(of: nftId) {
            favouriteList.remove(at: index)
        } else {
            favouriteList.append(nftId)
        }
        
        profileService.sendExamplePutRequest(likes: favouriteList, avatar: profile.avatar, name: profile.name) { [weak self] result in
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
