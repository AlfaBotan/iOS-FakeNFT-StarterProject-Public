import Foundation

final class FavouritesNftViewModel {
    
    private var nftData: [NFT] = [
        NFT(imageName: "11", name: "Archie", author: "John Doe", price: 1.78, rating: 1),
        NFT(imageName: "13", name: "Pixi", author: "John Doe", price: 1.78, rating: 3),
        NFT(imageName: "10", name: "Melissa", author: "John Doe", price: 1.78, rating: 5),
        NFT(imageName: "1", name: "April", author: "John Doe", price: 1.78, rating: 2),
        NFT(imageName: "12", name: "Daisy", author: "John Doe", price: 1.78, rating: 1),
        NFT(imageName: "2", name: "Lilo", author: "John Doe", price: 1.78, rating: 4)
    ]
    
    // Функция для получения данных
    func getNftData() -> [NFT] {
        return nftData
    }
    
    // Функция для удаления NFT из избранного
    func removeFromFavourites(at index: Int) {
        guard index >= 0 && index < nftData.count else { return }
        nftData.remove(at: index)
    }
}
