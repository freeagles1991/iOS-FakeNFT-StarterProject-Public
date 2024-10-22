//
//  CartPresenter.swift
//  FakeNFT
//
//  Created by Дима on 11.10.2024.
//

import Foundation

protocol CartPresenter {
    var serviceAssembler: ServicesAssembly { get }
    func getNFTs() -> [Nft]?
    func viewDidLoad()
    func filterButtonTapped()
    func payButtonTapped()
    func deleteNftFromCart(with id: String)
}

final class CartPresenterImpl: CartPresenter {
    weak var view: CartView?
    var serviceAssembler: ServicesAssembly
    private let nftService: NftService
    
    //Свичер для моковых nft
    let isUsingDefaultNFTs: Bool = false
    
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
            view.configureTotalCost(totalPrice: getNftsTotalPrice(), nftsCount: self.nfts.count)
            
        }
    }
    
    init(nftService: NftService, serviceAssembler: ServicesAssembly) {
        self.serviceAssembler = serviceAssembler
        self.nftService = nftService
        
        NotificationCenter.default.addObserver(self, selector: #selector(cartDidChange), name: CartStore.cartChangedNotification, object: nil)
        
        //"Добавляем" в корзину nft для тестов
        addNftToCart(nftIDs: testNFTsInCart)
    }
    
    //MARK: Public
    func viewDidLoad() {
        if isUsingDefaultNFTs {
            nfts.append(Nft())
        } else {
            guard let view else {return}
            view.showLoading()
            loadNfts(byIDs: testNFTs) { [weak self] in
                guard
                    let self
                else {return}
                self.updateNfts()
                view.switchCollectionViewState(isEmptyList: nfts.isEmpty)
                view.updateCollectionView()
                view.configureTotalCost(totalPrice: getNftsTotalPrice(), nftsCount: self.nfts.count)
                view.hideLoading()
            }
        }
    }
    
    func deleteNftFromCart(with id: String) {
        CartStore.nftsInCart.remove(id)
        print("CartPresenter: удалил \(id)")
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
    @objc private func cartDidChange() {
        updateNfts()
    }
    
    private func updateNfts() {
        guard let nfts = self.getNFTsInCartByID(nftsInCart: Array(CartStore.nftsInCart)) else { return }
        self.nfts = nfts
    }
    
    private func getNFTsInCartByID(nftsInCart: [String]) -> [Nft]? {
        var nfts: [Nft] = []
        for id in nftsInCart {
            nftService.loadNft(id: id) { result in
                switch result {
                case .success(let nft):
                    nfts.append(nft)
                    print("CartPresenterImpl: Успешно загружен nft \(nft.name), ID = \(nft.id)")
                case .failure(let error):
                    print("CartPresenterImpl: Ошибка при загрузке nft \(error)")
                }
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
