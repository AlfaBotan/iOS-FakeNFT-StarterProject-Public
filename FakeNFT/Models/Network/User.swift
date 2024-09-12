//
//  User.swift
//  FakeNFT
//
//  Created by Дмитрий on 13.09.2024.
//

import Foundation

// MARK: - User
struct User: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let rating: Int
    let id: String
}

typealias Users = [User]
