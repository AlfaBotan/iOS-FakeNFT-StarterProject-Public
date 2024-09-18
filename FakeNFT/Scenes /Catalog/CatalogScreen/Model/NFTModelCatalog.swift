//
//  NFTRowForTableView.swift
//  FakeNFT
//
//  Created by Илья Волощик on 9.09.24.
//

import UIKit

struct NFTModelCatalog: Codable {
    let createdAt: String
    let name: String
    let cover: URL
    let nfts: [String]
    let description: String
    let author: String
    let id: String
}

typealias NFTsModelCatalog = [NFTModelCatalog]
typealias NFTsModelCatalogCompletion = (Result<NFTsModelCatalog, Error>) -> Void

