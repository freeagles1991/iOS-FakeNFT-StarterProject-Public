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
    static var nftsInCart: Set<String> {
        get {
            guard let data = UserDefaults.standard.data(forKey: cartKey),
                  let nftIDs = try? JSONDecoder().decode([String].self, from: data) else {
                return []
            }
            return Set(nftIDs) // Преобразуем массив в множество для уникальности
        }
        set {
            let nftArray = Array(newValue) // Преобразуем множество в массив для сохранения
            if let data = try? JSONEncoder().encode(nftArray) {
                UserDefaults.standard.set(data, forKey: cartKey)
            }
        }
    }
}
