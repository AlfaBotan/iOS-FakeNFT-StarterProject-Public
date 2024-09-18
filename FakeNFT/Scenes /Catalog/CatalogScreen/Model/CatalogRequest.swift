//
//  CatalogRequest.swift
//  FakeNFT
//
//  Created by Илья Волощик on 17.09.24.
//

import Foundation

struct CatalogRequest: NetworkRequest {
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections")
    }
    var dto: Dto?
}
