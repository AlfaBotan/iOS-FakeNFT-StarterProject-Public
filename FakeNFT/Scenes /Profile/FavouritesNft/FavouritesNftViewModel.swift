import Foundation

final class FavouritesNftViewModel {
    
    private let nftDataKey = "favouritesNftDataKey"
    
    // Массив данных NFT
    private var nftData: [Nft] = []
    
    var nftList: [String]
    
    init(nftList: [String]) {
        self.nftList = nftList
        loadNftData()
    }
    
    // Функция для получения данных
    func getNftData() -> [Nft] {
        return nftData
    }
    
    // Функция для удаления NFT из избранного
    func removeFromFavourites(at index: Int) {
        guard index >= 0 && index < nftData.count else { return }
        nftData.remove(at: index)
        saveNftData()
    }
    
    // Сохранение данных в UserDefaults
    private func saveNftData() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(nftData) {
            UserDefaults.standard.set(encoded, forKey: nftDataKey)
        }
    }
    
    private func loadNftData() {
        
    }
}
