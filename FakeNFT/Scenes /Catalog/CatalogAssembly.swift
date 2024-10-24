//  Created by Artem Morozov on 21.10.2024.


import UIKit

public final class CatalogAssembly {
    
    private let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    public func build() -> UIViewController {
        let catalogPresenter = CatalogPresenterImpl(servicesAssembly: servicesAssembly)
        let cataloViewController = CatalogViewController(presenter: catalogPresenter)
        catalogPresenter.view = cataloViewController
        return cataloViewController
    }
}
