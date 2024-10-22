//  Created by Artem Morozov on 14.10.2024.


import UIKit

protocol CatalogPresenter {
    var dataSource: [NftCollection] { get }
    var cellViewModels: [CatalogCellViewModel] { get }
    
    func viewDidLoad()
    func createSortAlertViewModel() -> AlertViewModel
    func getServicesAssembly() -> ServicesAssembly
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
    
    private let servicesAssembly: ServicesAssembly
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    func viewDidLoad() {
        loadNftCollections()
    }
    
    func loadNftCollections() {
        view?.showLoading()
        servicesAssembly.nftCollectionsService.loadNftCollection { [weak self] result in
            self?.view?.hideLoading()
            switch result {
                case .success(let nftCollections):
                self?.dataSource = nftCollections
            case .failure(_):
                self?.view?.showError(ErrorModel(message: "Ошибка получения данных", actionText: "Попробовать снова", action: {
                    self?.loadNftCollections()
                }))
            }
        }
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
    
    func getServicesAssembly() -> ServicesAssembly {
        servicesAssembly
    }
}
