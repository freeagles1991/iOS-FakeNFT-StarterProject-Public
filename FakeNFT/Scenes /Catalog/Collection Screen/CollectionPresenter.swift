//  Created by Artem Morozov on 14.10.2024.


import Foundation

protocol CollectionPresenter: AnyObject {
    func viewDidLoad()
    var selectedCollection: NftCollection { get }
}

final class CollectionPresenterImpl: CollectionPresenter {
    
    weak var view: CollectionViewControllerProtocol?
    
    var selectedCollection: NftCollection
    
    init(selectedCollection: NftCollection) {
        self.selectedCollection = selectedCollection
    }
    
    func viewDidLoad() {
        view?.updateUI()
    }
}
