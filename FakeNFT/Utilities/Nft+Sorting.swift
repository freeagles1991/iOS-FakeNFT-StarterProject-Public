//
//  Nft+Sorting.swift
//  FakeNFT
//
//  Created by Артур  Арсланов on 23.10.2024.
//

import Foundation

enum SortingMethod: String {
    case price, name, rating
}

extension SortingMethod {
    var displayName: String {
        switch self {
        case .price:
            return "По цене"
        case .name:
            return "По названию"
        case .rating:
            return "По рейтингу"
        }
    }
}
