//
//  ChooseCurrencyAssembly.swift
//  FakeNFT
//
//  Created by Дима on 16.10.2024.
//

import Foundation
import UIKit

public final class ChooseCurrencyAssembly {

    private let servicesAssembler: ServicesAssembly

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }

    public func build() -> UIViewController {
        let presenter = ChooseCurrencyPresenterImpl(currencyService: servicesAssembler.currencyService)
        
        let viewController = ChooseCurrencyViewControllerImpl(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}