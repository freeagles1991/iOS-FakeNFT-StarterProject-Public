//
//  ChooseCurrencyPresenter.swift
//  FakeNFT
//
//  Created by Дима on 16.10.2024.
//

import Foundation

protocol ChooseCurrencyPresenter {
    var currencies: [Currency] { get }
    var nftLargeImageURL: URL? { get set }
    func viewDidLoad()
    func currencyDidSelect(at indexPath: IndexPath)
    func payOrder(with nfts: [String])
}

final class ChooseCurrencyPresenterImpl: ChooseCurrencyPresenter {
    // MARK: - Public Properties
    weak var view: ChooseCurrencyViewController?
    var currencies: [Currency] = []
    var nftLargeImageURL: URL?
    
    // MARK: - Private Properties
    private let currencyService: CurrencyService
    
    private var selectedCurrency: IndexPath? {
        didSet {
            view?.updatePayButtonState(selectedCurrency != nil)
        }
    }
    
    // MARK: - Initializers
    init(currencyService: CurrencyService) {
        self.currencyService = currencyService
    }
    
    // MARK: - Public Methods
    func viewDidLoad() {
        guard let view else {return}
        view.showLoading()
        currencyService.loadCurrencyList { result in
            switch result {
            case .success(let currencies):
                self.currencies = currencies
                view.updateCollectionView()
                view.hideLoading()
            case .failure(let error):
                print("ChooseCurrencyPresenterImpl: Error while loading currencies \(error)")
            }
        }
    }
    
    func currencyDidSelect(at indexPath: IndexPath) {
        guard let view else {return}
        self.selectedCurrency = indexPath
        view.toogleSelectAtCell(at: indexPath, isSelected: true)
        view.showLoading()
        currencyService.setCurrencyIDBeforePayment(String(indexPath.row)) { result in
            switch result {
            case .success(let response):
                if response.success {
                    print("ChooseCurrencyPresenterImpl: Set currency \(response.id) is success: \(response.success)")
                }
            case .failure(let error):
                view.toogleSelectAtCell(at: indexPath, isSelected: false)
                print("ChooseCurrencyPresenterImpl: Error while set currency \(error)")
            }
            view.hideLoading()
        }
    }
    
    func payOrder(with nfts: [String]) {
        guard let view else {return}
        view.showLoading()
        currencyService.sendPutOrderAndPayRequest(nfts: nfts) { [weak self] result in
            switch result {
            case .success(_):
                print("ChooseCurrencyPresenterImpl: оплачено")
                let successPurchaseAssembly = SuccessPurchaseAssembly()
                if let successPurchaseVC = successPurchaseAssembly.build() as? SuccessPurchaseViewCotroller {
                    successPurchaseVC.modalPresentationStyle = .overFullScreen
                    successPurchaseVC.modalTransitionStyle = .crossDissolve
                    if let self, let nftLargeImageURL = self.nftLargeImageURL {
                        successPurchaseVC.configure(nftLargeImageURL: nftLargeImageURL)
                    }
                    
                    view.navigationController?.pushViewController(successPurchaseVC, animated: true)
                }
                CartStore.nftsInCart.removeAll()
            case .failure(_):
                print("ChooseCurrencyPresenterImpl: не оплачено")
                let action = AlertViewModel.AlertAction(
                    title: "Попробовать снова",
                    style: .default,
                    handler: {
                        guard let self else {return}
                        self.payOrder(with: Array(CartStore.nftsInCart))
                    })
                let alert = AlertViewModel(
                    title: ":(",
                    message: "Оплата не выполнена по неизвестной причине",
                    actions: [action],
                    preferredStyle: .alert
                )
                view.showAlert(alert)
            }
            view.hideLoading()
        }
    }
}
