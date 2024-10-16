//
//  CartAssembly.swift
//  FakeNFT
//
//  Created by Дима on 11.10.2024.
//

import Foundation
import UIKit

public final class CartAssembly {

    private let servicesAssembler: ServicesAssembly

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }

    public func build() -> UIViewController {
        let presenter = CartPresenterImpl(
            nftService: servicesAssembler.nftService
        )
        let viewController = CartViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
