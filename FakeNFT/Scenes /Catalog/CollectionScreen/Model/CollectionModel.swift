//
//  CollectionMiodel.swift
//  FakeNFT
//
//  Created by Илья Волощик on 10.09.24.
//

import Foundation
import ProgressHUD

final class CollectionModel {
    private let networkClient: NetworkClient
    private let storage: NftStorage
    
    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }
    
    func loadNft(id: String, completion: @escaping NftCompletion) {
        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: Nft.self) { result in
            switch result {
            case .success(let nft):
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadCollection(idArrys: [String], completion: @escaping NftsCompletion) {
        var nfts: Nfts = []
        ProgressHUD.show()
        let dispatchGroup = DispatchGroup()
        for i in idArrys {
            dispatchGroup.enter()
            loadNft(id: i) { (result: Result<Nft, any Error>) in
                switch result {
                case .success(let nft):
                    nfts.append(nft)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        ProgressHUD.dismiss()
        completion(.success(nfts))
        dispatchGroup.leave()
    }
}
