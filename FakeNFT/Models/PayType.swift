//
//  PayType.swift
//  FakeNFT
//
//  Created by Дима on 16.10.2024.
//

import Foundation
import UIKit

struct PayType {
    let imageString: String
    let name: String
    let code: String
    
    static let bitcoin = PayType(imageString: "bitcoin_icon", name: "Bitcoin", code: "BTC")
    static let dogecoin = PayType(imageString: "dogecoin_icon", name: "Dogecoin", code: "DOGE")
    static let tether = PayType(imageString: "tether_icon", name: "Tether", code: "USDT")
    static let apecoin = PayType(imageString: "apecoin_icon", name: "ApeCoin", code: "APE")
    static let solana = PayType(imageString: "solana_icon", name: "Solana", code: "SOL")
    static let ethereum = PayType(imageString: "ethereum_icon", name: "Ethereum", code: "ETH")
    static let cardano = PayType(imageString: "cardano_icon", name: "Cardano", code: "ADA")
    static let shibaInu = PayType(imageString: "shibaInu_icon", name: "Shiba Inu", code: "SHIB")
}


