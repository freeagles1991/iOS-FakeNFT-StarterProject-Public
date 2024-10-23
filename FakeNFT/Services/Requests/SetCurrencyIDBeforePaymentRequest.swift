//
//  SetCurrencyIDBeforePaymentRequest.swift
//  FakeNFT
//
//  Created by Дима on 19.10.2024.
//

import Foundation

struct SetCurrencyIDBeforePaymentRequest: NetworkRequest {
    let id: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/\(id)")
    }
    var dto: Dto?
}

