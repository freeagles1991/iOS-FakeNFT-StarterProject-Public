//
//  CartStore.swift
//  FakeNFT
//
//  Created by Дима on 11.10.2024.
//

import Foundation
import UIKit

final class CartStore {
    private static let cartKey = "nftsInCart"

    //Сохраняем и получаем IDшники NFT в корзине
    static var nftsInCart: [String] {
        get {
            guard let data = UserDefaults.standard.data(forKey: cartKey),
                  let nftIDs = try? JSONDecoder().decode([String].self, from: data) else {
                return []
            }
            return nftIDs
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: cartKey)
            }
        }
    }
}
