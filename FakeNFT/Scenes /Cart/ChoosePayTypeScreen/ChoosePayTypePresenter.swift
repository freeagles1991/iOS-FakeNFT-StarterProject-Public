//
//  ChoosePayTypePresenter.swift
//  FakeNFT
//
//  Created by Дима on 16.10.2024.
//

import Foundation

protocol ChoosePayTypePresenter {
    var payTypes: [PayType] { get }
    func viewDidLoad()
}

final class ChoosePayTypePresenterImpl: ChoosePayTypePresenter {
    weak var view: ChoosePayTypeViewController?
    
    var payTypes: [PayType] = [
        .bitcoin,
        .dogecoin,
        .tether,
        .apecoin,
        .solana,
        .ethereum,
        .cardano,
        .shibaInu
    ]
    
    func viewDidLoad() {
        
    }
}
