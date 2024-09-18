//
//  CollectionViewModel.swift
//  FakeNFT
//
//  Created by Илья Волощик on 10.09.24.
//

import UIKit
import ProgressHUD

protocol CollectionViewModelProtocol: AnyObject {
    func fetchCollections(completion: @escaping () -> Void)
    func numberOfCollections() -> Int
    func collection(at index: Int) -> Nft
    func getPickedCollection() -> NFTModelCatalog
    func fetchNFTs(completion: @escaping () -> Void)
}

final class CollectionViewModel: CollectionViewModelProtocol {
    private let collectionModel: CollectionModel
    private var pickedCollection: NFTModelCatalog
    private var NFTsFromCollection: Nfts = []
    
    init(pickedCollection: NFTModelCatalog, model: CollectionModel) {
        self.collectionModel = model
        self.pickedCollection = pickedCollection
    }
    
    func fetchCollections(completion: @escaping () -> Void) {
        ProgressHUD.show()
        ProgressHUD.animationType = .circleSpinFade
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        collectionModel.loadCollection(idArrys: pickedCollection.nfts) { [weak self] (result: Result<Nfts, any Error>) in
            guard let self = self else {return}
            switch result {
            case .success(let nfts):
                self.NFTsFromCollection = nfts
                ProgressHUD.dismiss()
                completion()
                print("Все NFT загрузились: \(nfts)")
            case .failure(let error):
                ProgressHUD.showError()
                print(error.localizedDescription)
                print("NFT не загрузились")
            }
        }
    }
    
    func fetchNFTs(completion: @escaping () -> Void) {
        
        let dispatchGroup = DispatchGroup()
        
        ProgressHUD.show()
        ProgressHUD.animationType = .circleSpinFade
        
        let idArray = pickedCollection.nfts
        var nftsArray: Nfts = []
        
        for i in idArray {
            dispatchGroup.enter()
            collectionModel.loadNft(id: i) { [weak self] (result: (Result<Nft, Error>)) in
                guard let self = self else {return}
                switch result {
                case .success(let nft):
                    nftsArray.append(nft)
                case .failure(let error):
                    ProgressHUD.showError()
                    print(error.localizedDescription)
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print(nftsArray.count)
            ProgressHUD.dismiss()
            self.NFTsFromCollection = nftsArray
            completion()
        }
    }
    
    func numberOfCollections() -> Int {
        return NFTsFromCollection.count
    }
    
    func collection(at index: Int) -> Nft {
        return NFTsFromCollection[index]
    }
    
    func getPickedCollection() -> NFTModelCatalog {
        return pickedCollection
    }
}
