//
//  CartPresenter.swift
//  FakeNFT
//
//  Created by Дима on 11.10.2024.
//

import Foundation

protocol CartPresenter {
    func getNFTsInCartByID(nftsInCart: [String]) -> [Nft]?
    func loadNfts(byIDs ids: [String], completion: @escaping () -> Void)
}

final class CartPresenterImpl: CartPresenter {
    weak var view: CartView?
    private let nftService: NftService
    
    init(nftService: NftService) {
        self.nftService = nftService
    }
    
    func getNFTsInCartByID(nftsInCart: [String]) -> [Nft]? {
        var nfts: [Nft] = []
        for id in nftsInCart {
            if let nft = nftService.getNftFromStorageByID(with: id) {
                nfts.append(nft)
                print("Добавил \(nft.id)")
            }
        }
        
        return nfts
    }
    
    func loadNfts(byIDs ids: [String], completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        ids.forEach { id in
            dispatchGroup.enter()
            nftService.loadNft(id: id) { result in
                switch result {
                case .success(let nft):
                    // Handle successful loading of the NFT
                    print("Loaded NFT: \(nft)")
                case .failure(let error):
                    // Handle the error
                    print("Failed to load NFT: \(error.localizedDescription)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
}
