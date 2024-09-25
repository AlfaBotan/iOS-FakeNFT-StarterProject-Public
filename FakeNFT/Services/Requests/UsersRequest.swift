//
//  UsersRequest.swift
//  FakeNFT
//
//  Created by Дмитрий on 21.09.2024.
//

import Foundation

struct UsersRequest: NetworkRequest {
    let page: Int
    let size: Int
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users?page=\(page)&size=\(size)")
    }
    
    var dto: Dto?
}
