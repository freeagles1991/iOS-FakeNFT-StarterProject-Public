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
}

final class ChooseCurrencyPresenterImpl: ChooseCurrencyPresenter {
    weak var view: ChooseCurrencyViewController?
    private let currencyService: CurrencyService
    
    var currencies: [Currency] = []
    
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
}
