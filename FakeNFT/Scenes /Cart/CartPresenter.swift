//
//  CartPresenter.swift
//  FakeNFT
//
//  Created by Дима on 11.10.2024.
//

import Foundation

protocol CartPresenter {
    func getNFTs() -> [Nft]?
    func removeFromNFTs(at index: Int)
    func viewDidLoad()
    func filterButtonTapped()
    func payButtonTapped()
    func deleteNftFromCart(with id: String)
}

final class CartPresenterImpl: CartPresenter {
    // MARK: - Public Properties
    weak var view: CartView?
    var serviceAssembler: ServicesAssembly
    
    // MARK: - Private Properties
    private let nftService: NftService
    
    //Свичер для моковых nft
    private let isUsingDefaultNFTs: Bool = false
    
    private let testNFTs: [String] = [
    "1464520d-1659-4055-8a79-4593b9569e48",
    "b2f44171-7dcd-46d7-a6d3-e2109aacf520",
    "fa03574c-9067-45ad-9379-e3ed2d70df78"
    ]
    
    private let testNFTsInCart: [String] = [
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
    
    // MARK: - Initializers
    init(nftService: NftService, serviceAssembler: ServicesAssembly) {
        self.serviceAssembler = serviceAssembler
        self.nftService = nftService
        
        NotificationCenter.default.addObserver(self, selector: #selector(cartDidChange), name: CartStore.cartChangedNotification, object: nil)
        
        //"Добавляем" в корзину nft для тестов
        addNftToCart(nftIDs: testNFTsInCart)
    }
    
    // MARK: - Actions
    @objc private func cartDidChange() {
        updateNfts()
    }
    
    // MARK: - Public Methods
    func viewDidLoad() {
        updateCart()
    }
    
    func deleteNftFromCart(with id: String) {
        CartStore.nftsInCart.remove(id)
        print("CartPresenter: удалил \(id)")
    }
    
    func getNFTs() -> [Nft]? {
        return nfts
    }
    
    func removeFromNFTs(at index: Int) {
        nfts.remove(at: index)
    }
    
    func filterButtonTapped() {
        print("CartPresenter: filter button tapped")
    }
    
    func payButtonTapped() {
        print("CartPresenter: pay button tapped")
        let payAssembly = ChooseCurrencyAssembly(servicesAssembler: serviceAssembler)
        let payViewController = payAssembly.build()
        payViewController.hidesBottomBarWhenPushed = true
        
        guard let view else { return }
        view.setupNavigationBarForNextScreen()
        view.navigationController?.pushViewController(payViewController, animated: true)
    }
    
    //MARK: Private
    private func updateNfts() {
        getNFTsInCartByID(nftsInCart: Array(CartStore.nftsInCart),completion: { nfts in
            self.nfts = nfts
        } )
    }
    
    //Здесь мы ассинхронно загружаем nft, которые добавлены в корзину
    private func getNFTsInCartByID(nftsInCart: [String], completion: @escaping ([Nft]) -> Void) {
        var nfts: [Nft] = []
        let dispatchGroup = DispatchGroup()
        
        for id in nftsInCart {
            dispatchGroup.enter()
            
            nftService.loadNft(id: id) { [weak self] result in
                switch result {
                case .success(let nft):
                    nfts.append(nft)
                    print("CartPresenterImpl: Успешно загружен nft \(nft.name), ID = \(nft.id)")
                case .failure(let error):
                    print("CartPresenterImpl: Ошибка при загрузке nft \(error)")
                    guard let self, let view = self.view else {return}
                    
                    let action = AlertViewModel.AlertAction(title: "Попробовать снова", style: .default) {
                        self.updateNfts()
                    }
                    
                    let alert = AlertViewModel(title: "Упс", message: "Загрузка не удалась", actions: [action], preferredStyle: .alert)
                    view.showAlert(alert)
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(nfts)
        }
    }
    
    //Этот метод нужен только для тестирования, загружает несколько nft по списку как будто из каталога
    private func loadNfts(byIDs ids: [String], completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        ids.forEach { id in
            dispatchGroup.enter()
            nftService.loadNft(id: id) { result in
                switch result {
                case .success(let nft):
                    print("Loaded NFT: \(nft)")
                case .failure(let error):
                    print("Failed to load NFT: \(error.localizedDescription)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    private func updateCart() {
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
