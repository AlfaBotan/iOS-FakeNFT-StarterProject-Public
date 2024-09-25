import Foundation

final class MyNftViewModel {
    
    private var nftData: [NFT] = [
        NFT(imageName: "2", name: "Lilo", author: "John Doe", price: 1.80, rating: 3),
        NFT(imageName: "3", name: "Spring", author: "John Doe", price: 1.78, rating: 3),
        NFT(imageName: "1", name: "April", author: "John Doe", price: 1.77, rating: 3)
    ]
    
    private let sortKey = "nftSortType"
    
    // Типы сортировки
    enum SortType: String {
        case name, price, rating
    }
    
    // Данные, которые будут доступны для View
    var filteredNftData: [NFT] {
        return nftData
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
