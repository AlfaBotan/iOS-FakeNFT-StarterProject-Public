import Foundation

final class MyNftViewModel {
    
    // Пример данных NFT
    private var nftData: [NFT] = [
        NFT(imageName: "2", name: "Lilo", author: "John Doe", price: 1.78, rating: 3),
        NFT(imageName: "3", name: "Spring", author: "John Doe", price: 1.78, rating: 3),
        NFT(imageName: "1", name: "April", author: "John Doe", price: 1.78, rating: 3)
    ]
    
    // Данные, которые будут доступны для View
    var filteredNftData: [NFT] {
        return nftData
    }
    
    // Метод сортировки по имени
    func sortByName() {
        nftData.sort { $0.name < $1.name }
    }
    
    // Метод сортировки по цене
    func sortByPrice() {
        nftData.sort { $0.price < $1.price }
    }
    
    // Метод сортировки по рейтингу
    func sortByRating() {
        nftData.sort { $0.rating > $1.rating }
    }
}

