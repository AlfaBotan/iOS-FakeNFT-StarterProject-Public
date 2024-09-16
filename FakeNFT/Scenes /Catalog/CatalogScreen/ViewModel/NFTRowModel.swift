//
//  NFTRowForTableView.swift
//  FakeNFT
//
//  Created by Илья Волощик on 9.09.24.
//

import UIKit

struct NFTRowModel {
    let image: UIImage
    let name: String
    let count: Int
}

struct NFTModelCatalog: Codable {
    let createdAt: String
    let name: String
    let cover: String
    let nfts: [String]
    let description: String
    let author: String
    let id: String
}
