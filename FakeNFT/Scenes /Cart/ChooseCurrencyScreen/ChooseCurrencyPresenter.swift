//
//  ChooseCurrencyPresenter.swift
//  FakeNFT
//
//  Created by Дима on 16.10.2024.
//

import Foundation

protocol ChooseCurrencyPresenter {
    var currencies: [Currency] { get }
    func viewDidLoad()
    func currencyDidSelect(at indexPath: IndexPath)
    func payOrder(with nfts: [String])
}

final class ChooseCurrencyPresenterImpl: ChooseCurrencyPresenter {
    weak var view: ChooseCurrencyViewController?
    private let currencyService: CurrencyService
    
    var currencies: [Currency] = []
    var selectedCurrency: IndexPath? {
        didSet {
            view?.updatePayButtonState(selectedCurrency != nil)
        }
    }
    
    init(currencyService: CurrencyService) {
        self.currencyService = currencyService
    }
    
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
        currencyService.sendPutOrderAndPayRequest(nfts: nfts) { result in
            switch result {
            case .success(_):
                print("ChooseCurrencyPresenterImpl: оплачено")
                let action = AlertViewModel.AlertAction(
                    title: "Окей", 
                    style: .default,
                    handler: {
                        self.view?.navigationController?.popViewController(animated: true)
                    }
                )
                let alert = AlertViewModel(
                    title: "Ура",
                    message: "Вы купили \(CartStore.nftsInCart.count) NFT",
                    actions: [action],
                    preferredStyle: .alert
                )
                view.showAlert(alert)
                CartStore.nftsInCart.removeAll()
            case .failure(_):
                print("ChooseCurrencyPresenterImpl: не оплачено")
                print("ChooseCurrencyPresenterImpl: оплачено")
                let action = AlertViewModel.AlertAction(
                    title: "Попробовать снова",
                    style: .default,
                    handler: {
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
