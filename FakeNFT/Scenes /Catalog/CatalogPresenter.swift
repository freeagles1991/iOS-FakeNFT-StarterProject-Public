//  Created by Artem Morozov on 14.10.2024.


import UIKit

protocol CatalogPresenter {
    func viewDidLoad()
    func createSortAlertViewModel() -> AlertViewModel
    var dataSource: [NftCollection] { get }
    var cellViewModels: [CatalogCellViewModel] { get }
}

final class CatalogPresenterImpl: CatalogPresenter {
    
    weak var view: CatalogViewControllerProtocol?
    
    var dataSource: [NftCollection] = [] {
        didSet {
            view?.updateUI()
        }
    }
    
    var cellViewModels: [CatalogCellViewModel] {
        return dataSource.map { collection in
            let title = "\(collection.name) (\(collection.nfts.count))"
            let imageURL = URL(string: collection.cover)
            return CatalogCellViewModel(imageURL: imageURL, title: title)
        }
    }
    
    func viewDidLoad() {
        dataSource.append(contentsOf: [NftCollection(createdAt: "2023 - 11- 21:36",
                                                     name: "Peach",
                                                     cover: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Brown.png",
                                                     nfts: ["c14cf3bc-7470-4eec-8a42-5eaa65f4053c", "d6a02bd1-1255-46cd-815b-656174c1d9c0"],
                                                     description: "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей.",
                                                     author: "John Doe",
                                                     id: "d4fea6b6-91f1-45ce-9745-55431e69ef5c"),
                                       NftCollection(createdAt: "2023 - 11- 21:36",
                                                     name: "Peach",
                                                     cover: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Brown.png",
                                                     nfts: ["c14cf3bc-7470-4eec-8a42-5eaa65f4053c", "d6a02bd1-1255-46cd-815b-656174c1d9c0"],
                                                     description: "curabitur feugait a definitiones singulis movet eros aeque mucius evertitur assueverit et eam",
                                                     author: "Lourdes Harper",
                                                     id: "d4fea6b6-91f1-45ce-9745-55431e69ef5c"),
                                       NftCollection(createdAt: "2023 - 11- 21:36",
                                                     name: "Peach",
                                                     cover: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Brown.png",
                                                     nfts: ["c14cf3bc-7470-4eec-8a42-5eaa65f4053c", "d6a02bd1-1255-46cd-815b-656174c1d9c0"],
                                                     description: "curabitur feugait a definitiones singulis movet eros aeque mucius evertitur assueverit et eam",
                                                     author: "Lourdes Harper",
                                                     id: "d4fea6b6-91f1-45ce-9745-55431e69ef5c"),
                                       NftCollection(createdAt: "2023 - 11- 21:36",
                                                     name: "Peach",
                                                     cover: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Brown.png",
                                                     nfts: ["c14cf3bc-7470-4eec-8a42-5eaa65f4053c", "d6a02bd1-1255-46cd-815b-656174c1d9c0"],
                                                     description: "curabitur feugait a definitiones singulis movet eros aeque mucius evertitur assueverit et eam",
                                                     author: "Lourdes Harper",
                                                     id: "d4fea6b6-91f1-45ce-9745-55431e69ef5c")])
    }
    
    func createSortAlertViewModel() -> AlertViewModel {
        let alertViewModel = AlertViewModel(title: "Сортировка",
                                            message: nil,
                                            actions: [
                                                AlertViewModel.AlertAction(title: "По названию", style: .default) {
                                                    print("Сортировку сделаю в 3 модуле")
                                                },
                                                
                                                AlertViewModel.AlertAction(title: "По количеству NFT", style: .default) {
                                                    print("Сортировку сделаю в 3 модуле")
                                                },
                                                
                                                AlertViewModel.AlertAction(title: "Закрыть", style: .cancel, handler: nil)
                                            ],
                                            preferredStyle: .actionSheet)
        return alertViewModel
    }
}
