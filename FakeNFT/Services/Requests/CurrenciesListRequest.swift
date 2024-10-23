//
//  CurrenciesListRequest.swift
//  FakeNFT
//
//  Created by Дима on 18.10.2024.
//

import Foundation

struct CurrenciesListRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
    }
    var dto: Dto?
}
