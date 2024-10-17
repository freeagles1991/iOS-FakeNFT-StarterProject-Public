//
//  ChoosePayTypeAssembly.swift
//  FakeNFT
//
//  Created by Дима on 16.10.2024.
//

import Foundation
import UIKit

public final class ChoosePayTypeAssembly {

    private let servicesAssembler: ServicesAssembly

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }

    public func build() -> UIViewController {
        let presenter = ChoosePayTypePresenterImpl()
        
        let viewController = ChoosePayTypeViewControllerImpl(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
