//
//  Currency.swift
//  FakeNFT
//
//  Created by Дима on 18.10.2024.
//

import Foundation

struct Currency: Codable {
    let title: String
    let name: String
    let image: String
    let id: String
}

struct SetCurrencyIDResponse: Codable {
    let success: Bool
    let orderId: String
    let id: String
}
