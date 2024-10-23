//
//  Nft+Sorting.swift
//  FakeNFT
//
//  Created by Артур  Арсланов on 23.10.2024.
//

import Foundation

enum SortCriterion: String {
    case price, name, rating
}

extension Nft {
    func compare(with other: Nft, by criterion: SortCriterion) -> Bool {
        switch criterion {
        case .price:
            return price < other.price
        case .name:
            return name < other.name
        case .rating:
            return rating > other.rating
        }
    }
}

extension SortCriterion {
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
