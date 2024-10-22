//  Created by Artem Morozov on 21.10.2024.


import UIKit

public final class CatalogAssembly {
    
    private let servicesAssembler: ServicesAssembly

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }
    
    public func build() -> UIViewController {
        let catalogPresenter = CatalogPresenterImpl(servicesAssembly: servicesAssembler)
        let cataloViewController = CatalogViewController(presenter: catalogPresenter)
        catalogPresenter.view = cataloViewController
        return cataloViewController
    }
}
