import Foundation

final class FavouritesNftViewModel {
    
    private let nftDataKey = "favouritesNftDataKey"
    
    // Массив данных NFT
    private var nftData: [NFT] = []
    
    init() {
        // Загружаем данные при инициализации
        loadNftData()
    }
    
    // Функция для получения данных
    func getNftData() -> [NFT] {
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
    
    // Загрузка данных из UserDefaults
    private func loadNftData() {
        if let savedData = UserDefaults.standard.data(forKey: nftDataKey) {
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode([NFT].self, from: savedData) {
                nftData = decodedData
            }
        } else {
            // Если данных нет, загружаем стандартный набор данных
            nftData = [
                NFT(imageName: "11", name: "Archie", author: "John Doe", price: 1.78, rating: 1),
                NFT(imageName: "13", name: "Pixi", author: "John Doe", price: 1.78, rating: 3),
                NFT(imageName: "10", name: "Melissa", author: "John Doe", price: 1.78, rating: 5),
                NFT(imageName: "1", name: "April", author: "John Doe", price: 1.78, rating: 2),
                NFT(imageName: "12", name: "Daisy", author: "John Doe", price: 1.78, rating: 1),
                NFT(imageName: "2", name: "Lilo", author: "John Doe", price: 1.78, rating: 4)
            ]
        }
    }
}
