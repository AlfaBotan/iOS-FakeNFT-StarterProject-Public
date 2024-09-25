import Foundation

final class MyNftViewModel {
    
    private var nftData: [NFT] = [
        NFT(imageName: "2", name: "Lilo", author: "John Doe", price: 1.80, rating: 3),
        NFT(imageName: "3", name: "Spring", author: "John Doe", price: 1.78, rating: 3),
        NFT(imageName: "1", name: "April", author: "John Doe", price: 1.77, rating: 3)
    ]
    
    private let favouritesKey = "favouritesNftKey"
    private let sortKey = "nftSortType"
    
    // Типы сортировки
    enum SortType: String {
        case name, price, rating
    }
    
    // Избранные NFT
    private(set) var favourites: [NFT] {
        get {
            if let savedData = UserDefaults.standard.data(forKey: favouritesKey),
               let decoded = try? JSONDecoder().decode([NFT].self, from: savedData) {
                return decoded
            }
            return []
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: favouritesKey)
            }
        }
    }
    
    // Данные, которые будут доступны для View
    var filteredNftData: [NFT] {
        return nftData
    }
    
    // Добавляем в избранные
    func addToFavourites(_ nft: NFT) {
        var currentFavourites = favourites
        if !currentFavourites.contains(where: { $0.name == nft.name }) {
            currentFavourites.append(nft)
            favourites = currentFavourites
        }
    }
    
    // Метод для применения сортировки при загрузке
    func applySavedSort() {
        let savedSort = UserDefaults.standard.string(forKey: sortKey) ?? SortType.name.rawValue
        sort(by: SortType(rawValue: savedSort) ?? .name)
    }
    
    // Метод для сортировки по выбранному типу
    func sort(by type: SortType) {
        switch type {
        case .name:
            sortByName()
        case .price:
            sortByPrice()
        case .rating:
            sortByRating()
        }
        
        // Сохранение выбранной сортировки
        UserDefaults.standard.set(type.rawValue, forKey: sortKey)
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
}
