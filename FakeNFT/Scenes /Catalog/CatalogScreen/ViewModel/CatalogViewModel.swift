//
//  CatalogViewModel.swift
//  FakeNFT
//
//  Created by Илья Волощик on 9.09.24.
//

import UIKit

class CatalogViewModel {
    private var collections: [NFTRowModel] = []
    
    func fetchCollections(completion: @escaping () -> Void) {
        // Здесь будет запрос к сервису для загрузки данных
        // После загрузки данных обновим массив collections
        guard let image = UIImage(named: "peachMini") else {return}
        collections = [NFTRowModel(image: image, name: "Peach", count: 11),
                       NFTRowModel(image: image, name: "Peach", count: 11),
                       NFTRowModel(image: image, name: "Peach", count: 11),
                       NFTRowModel(image: image, name: "Peach", count: 11),
                       NFTRowModel(image: image, name: "Peach", count: 11)]
        completion()
    }
    
    func numberOfCollections() -> Int {
        return collections.count
    }
    
    func collection(at index: Int) -> NFTRowModel {
        return collections[index]
    }
}
