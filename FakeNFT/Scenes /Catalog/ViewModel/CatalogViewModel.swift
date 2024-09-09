//
//  CatalogViewModel.swift
//  FakeNFT
//
//  Created by Илья Волощик on 9.09.24.
//

import UIKit

class CatalogViewModel {
    private var collections: [NFTRowForTableView] = []
    
        func fetchCollections(completion: @escaping () -> Void) {
            // Здесь будет запрос к сервису для загрузки данных
            // После загрузки данных обновим массив collections
            guard let image = UIImage(named: "peach") else {return}
            collections = [NFTRowForTableView(image: image, name: "Peach", count: 11), NFTRowForTableView(image: image, name: "Peach", count: 11), NFTRowForTableView(image: image, name: "Peach", count: 11), NFTRowForTableView(image: image, name: "Peach", count: 11), NFTRowForTableView(image: image, name: "Peach", count: 11)]
            completion()
        }

        // Методы для получения данных для UI
        func numberOfCollections() -> Int {
            return collections.count
        }

        func collection(at index: Int) -> NFTRowForTableView {
            return collections[index]
        }
}
