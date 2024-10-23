//
//  CurrencyRequest.swift
//  FakeNFT
//
//  Created by Дима on 18.10.2024.
//

import Foundation

struct CurrencyRequest: NetworkRequest {
    let id: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies/\(id)")
    }
    var dto: Dto?
}
