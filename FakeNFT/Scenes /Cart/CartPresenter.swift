//
//  CartPresenter.swift
//  FakeNFT
//
//  Created by Дима on 11.10.2024.
//

import Foundation

protocol CartPresenter {
    func getNFTs() -> [Nft]?
    func viewDidLoad()
    func filterButtonTapped()
    func payButtonTapped()
}

final class CartPresenterImpl: CartPresenter {
    weak var view: CartView?
    private let nftService: NftService
    
    let testNFTs: [String] = [
    "1464520d-1659-4055-8a79-4593b9569e48",
    "b2f44171-7dcd-46d7-a6d3-e2109aacf520",
    "fa03574c-9067-45ad-9379-e3ed2d70df78"
    ]
    
    let testNFTsInCart: [String] = [
    "1464520d-1659-4055-8a79-4593b9569e48",
    "b2f44171-7dcd-46d7-a6d3-e2109aacf520"
    ]
    
    private var nfts: [Nft] = [] {
        didSet {
            guard let view else {return}
            view.switchCollectionViewState(isEmptyList: nfts.isEmpty)
            view.updateCollectionView()
            view.configureTotalCost(totalPrice: getNftsTotalPrice(), nftsCount: self.nfts.count)
            
        }
    }
    
    init(nftService: NftService) {
        self.nftService = nftService
        //"Добавляем" в корзину nft для тестов
        addNftToCart(nftIDs: testNFTsInCart)
    }
    //MARK: Public
    func viewDidLoad() {
        guard let view else {return}
        loadNfts(byIDs: testNFTs) { [weak self] in
            guard
                let self,
                let nfts = self.getNFTsInCartByID(nftsInCart: Array(CartStore.nftsInCart))
            else {return}
            self.nfts = nfts
            view.switchCollectionViewState(isEmptyList: nfts.isEmpty)
            view.updateCollectionView()
            view.configureTotalCost(totalPrice: getNftsTotalPrice(), nftsCount: self.nfts.count)
        }
    }
    
    func getNFTs() -> [Nft]? {
        return nfts
    }
    
    func filterButtonTapped() {
        print("CartPresenter: filter button tapped")
    }
    
    func payButtonTapped() {
        print("CartPresenter: pay button tapped")
    }
    
    //MARK: Private
    private func getNFTsInCartByID(nftsInCart: [String]) -> [Nft]? {
        var nfts: [Nft] = []
        for id in nftsInCart {
            if let nft = nftService.getNftFromStorageByID(with: id) {
                nfts.append(nft)
                print("Добавил \(nft.id)")
            }
        }
        
        return nfts
    }
    
    private func loadNfts(byIDs ids: [String], completion: @escaping () -> Void) {
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
    
    private func getNftsTotalPrice() -> Double{
        var price: Double = 0
        for nft in nfts {
            price = price + nft.price
        }
        return price
    }
    
    private func addNftToCart(nftIDs: [String]) {
        CartStore.nftsInCart.formUnion(nftIDs)
    }
}
