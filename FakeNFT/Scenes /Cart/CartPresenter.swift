//
//  CartPresenter.swift
//  FakeNFT
//
//  Created by Дима on 11.10.2024.
//

import Foundation

protocol CartPresenter {
    
}

final class CartPresenterImpl: CartPresenter {
    weak var view: CartView?
    private let nftService: NftService
    
    init(nftService: NftService) {
        self.nftService = nftService
    }
}
