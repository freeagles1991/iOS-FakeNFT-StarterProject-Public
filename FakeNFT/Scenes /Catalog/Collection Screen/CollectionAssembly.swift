//  Created by Artem Morozov on 21.10.2024.

import UIKit

public final class CollectionAssembly {
    
    private let servicesAssembly: ServicesAssembly
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    func build(selectedCollection: NftCollection) -> UIViewController {
        let collectionPresenter = CollectionPresenterImpl(selectedCollection: selectedCollection, nftService: servicesAssembly.nftService)
        let collectionVC = CollectionViewController(presenter: collectionPresenter)
        collectionPresenter.view = collectionVC
        return collectionVC
    }
}
