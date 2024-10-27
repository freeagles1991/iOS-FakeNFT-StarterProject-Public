//  Created by Artem Morozov on 14.10.2024.


import Foundation

protocol CollectionPresenter: AnyObject {
    var selectedCollection: NftCollection { get }
    var cellViewModels: [CollectionCellViewModel] { get }
    
    func viewDidLoad()
    func didTapCartButton(indexPath: IndexPath)
}

final class CollectionPresenterImpl: CollectionPresenter {
    
    weak var view: CollectionViewControllerProtocol?
    
    private var nftArray: [Nft] = []
    var selectedCollection: NftCollection
    var cellViewModels: [CollectionCellViewModel] {
        return nftArray.map { nft in
            let name = nft.name
            let image = nft.images.first
            let rating = nft.rating
            let price = nft.price
            let isAddedToCart = CartStore.nftsInCart.contains(nft.id)
            return CollectionCellViewModel(name: name, image: image, rating: rating, price: price, isAddedToCart: isAddedToCart, isFavorited: isAddedToCart)
        }
    }
    
    private let nftService: NftService
    
    init(selectedCollection: NftCollection, nftService: NftService) {
        self.selectedCollection = selectedCollection
        self.nftService = nftService
    }
    
    func viewDidLoad() {
        loadNfts()
    }
    
    func loadNfts() {
        guard !selectedCollection.nfts.isEmpty else {return}
        view?.showLoading()
        let dispatchGroup = DispatchGroup()
        selectedCollection.nfts.forEach { id in
            dispatchGroup.enter()
            nftService.loadNft(id: id) { [weak self] result in
                switch result {
                case .success(let nft):
                    self?.nftArray.append(nft)
                case .failure(_):
                    self?.view?.showError(ErrorModel(message: "Ошибка получения данных", actionText: "Попробовать снова", action: { [weak self] in
                        self?.loadNfts()
                    }))
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print(self.nftArray)
            self.view?.updateUI()
            self.view?.hideLoading()
        }
    }
    
    func didTapCartButton(indexPath: IndexPath) {
        guard indexPath.row < nftArray.count else {return}
        let currentNft = nftArray[indexPath.row]
        let isAddedToCart = CartStore.nftsInCart.contains(currentNft.id)
        if isAddedToCart {
            CartStore.nftsInCart.remove(currentNft.id)
        } else {
            CartStore.nftsInCart.insert(currentNft.id)
        }
        view?.updateCell(cellIndexPath: indexPath)
        
    }
}
