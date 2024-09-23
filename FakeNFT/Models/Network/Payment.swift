//
//  Payment.swift
//  FakeNFT
//
//  Created by Alexander Salagubov on 18.09.2024.
//

import Foundation

struct Payment: Codable {
    let success: Bool
    let orderId: String
    let id: String
}
