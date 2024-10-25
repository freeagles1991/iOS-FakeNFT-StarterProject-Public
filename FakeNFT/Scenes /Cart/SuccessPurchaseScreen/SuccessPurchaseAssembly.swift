//
//  SuccessPurchaseAssembly.swift
//  FakeNFT
//
//  Created by Дима on 24.10.2024.
//

import Foundation
import UIKit

final class SuccessPurchaseAssembly {
    public func build() -> UIViewController {
        let presenter = SuccessPurchasePresenterImpl()
        let viewController = SuccessPurchaseViewControllerImpl(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
