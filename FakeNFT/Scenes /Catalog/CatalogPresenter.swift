//  Created by Artem Morozov on 14.10.2024.


import UIKit

protocol CatalogPresenter {
    func viewDidLoad()
}

final class CatalogPresenterImpl: CatalogPresenter {
    
    weak var view: CatalogView?
    
    func viewDidLoad() {
        
    }
}
