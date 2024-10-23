//
//  SetCurrencyIDResponse.swift
//  FakeNFT
//
//  Created by Дима on 19.10.2024.
//

import Foundation

struct SetCurrencyIDResponse: Codable {
    let success: Bool
    let orderId: String
    let id: String
}
