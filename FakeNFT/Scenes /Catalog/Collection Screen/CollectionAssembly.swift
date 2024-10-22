//  Created by Artem Morozov on 21.10.2024.

import UIKit

public final class CollectionAssembly {
    
    private let servicesAssembler: ServicesAssembly
    
    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }
    
    func build(selectedCollection: NftCollection) -> UIViewController {
        let collectionPresenter = CollectionPresenterImpl(selectedCollection: selectedCollection, nftService: servicesAssembler.nftService)
        let collectionVC = CollectionViewController(presenter: collectionPresenter)
        collectionPresenter.view = collectionVC
        return collectionVC
    }
}
