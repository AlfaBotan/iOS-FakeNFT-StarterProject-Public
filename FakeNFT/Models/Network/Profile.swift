//
//  Profile.swift
//  FakeNFT
//
//  Created by Дмитрий on 20.09.2024.
//

import Foundation

// MARK: - Profile
struct Profile: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    var likes: [String]
    let id: String
}
