//
//  CollectionViewModel.swift
//  FakeNFT
//
//  Created by Илья Волощик on 10.09.24.
//

import UIKit

final class CollectionViewModel {
    private var collections: [NFTCellModel] = []
    
    func fetchCollections(completion: @escaping () -> Void) {
        // Здесь будет запрос к сервису для загрузки данных
        // После загрузки данных обновим массив collections
        guard let image = UIImage(named: "archie") else {return}
        collections = [NFTCellModel(image: image, rating: 1, name: "Archie", cost: 1, isLike: true, inCart: true),
                       NFTCellModel(image: image, rating: 2, name: "Archie", cost: 2, isLike: false, inCart: false),
                       NFTCellModel(image: image, rating: 3, name: "Archie", cost: 3, isLike: true, inCart: true),
                       NFTCellModel(image: image, rating: 4, name: "Archie", cost: 4, isLike: false, inCart: false),
                       NFTCellModel(image: image, rating: 5, name: "Archie", cost: 5, isLike: true, inCart: false),
                       NFTCellModel(image: image, rating: 1, name: "Archie", cost: 6, isLike: false, inCart: false),
                       NFTCellModel(image: image, rating: 1, name: "Archie", cost: 10, isLike: true, inCart: true),
                       NFTCellModel(image: image, rating: 1, name: "Archie", cost: 10, isLike: true, inCart: true),
                       NFTCellModel(image: image, rating: 1, name: "Archie", cost: 10, isLike: true, inCart: true),
                       NFTCellModel(image: image, rating: 1, name: "Archie", cost: 10, isLike: true, inCart: true),
                       NFTCellModel(image: image, rating: 1, name: "Archie", cost: 10, isLike: true, inCart: true)]
        completion()
    }
    
    func numberOfCollections() -> Int {
        return collections.count
    }
    
    func collection(at index: Int) -> NFTCellModel {
        return collections[index]
    }
}
