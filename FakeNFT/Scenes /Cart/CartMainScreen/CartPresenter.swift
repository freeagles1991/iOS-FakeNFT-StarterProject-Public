//
//  CartPresenter.swift
//  FakeNFT
//
//  Created by Дима on 11.10.2024.
//

import Foundation
import Kingfisher

protocol CartPresenter {
    func getNFTs() -> [Nft]?
    func viewDidLoad()
    func filterButtonTapped()
    func payButtonTapped()
    func removeButtonTapped(at indexPath: IndexPath)
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
    
    private var nftLargeImageURL: URL?
    
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
        updateNfts() { [weak self] in
            guard let self, let view else {return}
            view.switchCollectionViewState(isEmptyList: nfts.isEmpty)
            view.updateCollectionView()
            view.configureTotalCost(totalPrice: getNftsTotalPrice(), nftsCount: self.nfts.count)
        }
    }
    
    // MARK: - Public Methods
    func viewDidLoad() {
        updateCart()
        loadNftLargeImage()
    }
    
    func getNFTs() -> [Nft]? {
        return nfts
    }
    
    func filterButtonTapped() {
        print("CartPresenter: filter button tapped")
    }
    
    func payButtonTapped() {
        print("CartPresenter: pay button tapped")
        let payAssembly = ChooseCurrencyAssembly(servicesAssembler: serviceAssembler)
        guard let payViewController = payAssembly.build() as? ChooseCurrencyViewController else {return}
        payViewController.hidesBottomBarWhenPushed = true
        
        if let nftLargeImageURL {
            payViewController.configure(nftLargeImageURL: nftLargeImageURL)
        }

        guard let view else { return }
        view.setupNavigationBarForNextScreen()
        view.navigationController?.pushViewController(payViewController, animated: true)
    }
    
    func removeButtonTapped(at indexPath: IndexPath) {
        guard let view else {return}
        
        let removeFromCartAssembly = RemoveFromCartAssembly()
        guard let removeFromCartVC = removeFromCartAssembly.build() as? RemoveFromCartViewController else { return }
        removeFromCartVC.modalPresentationStyle = .overFullScreen
        removeFromCartVC.modalTransitionStyle = .crossDissolve
        
        removeFromCartVC.configureScreen(with: self.nfts[indexPath.row])

        removeFromCartVC.onConfirm = { [weak self] in
            print("Подтверждено через замыкание!")
            guard let self else {return}
            
            let nftID = self.nfts[indexPath.row].id
            
            removeFromNFTs(at: indexPath.row)
            
            view.performBatchUpdate(deletionAt: indexPath) { [weak self] in
                guard let self else {return}
                self.deleteNftFromCart(with: nftID)
            }
        }
        
        view.present(removeFromCartVC, animated: true, completion: nil)
    }
    
    //MARK: Private
    private func updateNfts(completion: @escaping ()-> Void) {
        getNFTsInCartByID(nftsInCart: Array(CartStore.nftsInCart),completion: { nfts in
            self.nfts = nfts
            print("CartPresenter: получены nft \(nfts)")
            completion()
        } )
    }
    
    private func removeFromNFTs(at index: Int) {
        nfts.remove(at: index)
    }
    
    private func deleteNftFromCart(with id: String) {
        CartStore.nftsInCart.remove(id)
        print("CartPresenter: удалил \(id)")
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
                        self.updateNfts() { [weak self] in
                            guard let self else {return}
                            view.switchCollectionViewState(isEmptyList: nfts.isEmpty)
                            view.updateCollectionView()
                            view.configureTotalCost(totalPrice: getNftsTotalPrice(), nftsCount: self.nfts.count)
                        }
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
    
    //Здесь мы ассинхронно загружаем в кэш большую картинку для экрана успешной покупки
    private func loadNftLargeImage() {
        guard let imageURL = nfts.first?.images[2] else { return }
        nftLargeImageURL = imageURL
        ImagePrefetcher(urls: [imageURL]).start()
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
                self.updateNfts() { [weak self] in
                    guard let self else { return }
                    view.switchCollectionViewState(isEmptyList: nfts.isEmpty)
                    view.updateCollectionView()
                    view.configureTotalCost(totalPrice: getNftsTotalPrice(), nftsCount: self.nfts.count)
                    view.hideLoading()
                }
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
