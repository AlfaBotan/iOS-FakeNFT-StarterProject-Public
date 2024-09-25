//
//  NFTCellModel.swift
//  FakeNFT
//
//  Created by Дмитрий on 09.09.2024.
//

import UIKit

struct NFTCellModel {
    let id: String
    let imageURL: URL
    let rating: Int
    let name: String
    let cost: Float
    let isLiked: Bool
    let inCart: Bool
}
