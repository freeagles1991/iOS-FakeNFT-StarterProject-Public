import Foundation
import UIKit

public final class CartAssembly {

    private let servicesAssembler: ServicesAssembly

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }

    public func build() -> UIViewController {
        let presenter = CartPresenterImpl(
            nftService: servicesAssembler.nftService,
            serviceAssembler: servicesAssembler
        )
        let viewController = CartViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
