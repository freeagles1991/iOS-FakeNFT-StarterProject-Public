//  Created by Artem Morozov on 14.10.2024.


import Foundation

protocol CollectionPresenter: AnyObject {
    var selectedCollection: NftCollection { get }
    var cellViewModels: [CollectionCellViewModel] { get }
    
    func viewDidLoad()
    func didTapCartButton(indexPath: IndexPath)
    func didTapLikeButton(indexPath: IndexPath)
}

final class CollectionPresenterImpl: CollectionPresenter {
    
    weak var view: CollectionViewControllerProtocol?
    
    private var nftArray: [Nft] = []
    private var userProfile: UserProfile?
    var selectedCollection: NftCollection
    var cellViewModels: [CollectionCellViewModel] {
        return nftArray.map { nft in
            let name = nft.name
            let image = nft.images.first
            let rating = nft.rating
            let price = nft.price
            let isAddedToCart = CartStore.nftsInCart.contains(nft.id)
            let isLiked = userProfile?.likes.contains(nft.id)
            return CollectionCellViewModel(name: name, image: image, rating: rating, price: price, isAddedToCart: isAddedToCart, isFavorited: isLiked ?? false)
        }
    }
    
    private let servicesAssembly: ServicesAssembly
    
    init(selectedCollection: NftCollection, servicesAssembly: ServicesAssembly) {
        self.selectedCollection = selectedCollection
        self.servicesAssembly = servicesAssembly
    }
    
    func viewDidLoad() {
        loadData()
    }
    
    func loadData() {
        guard !selectedCollection.nfts.isEmpty else {return}
        view?.showLoading()
        let dispatchGroup = DispatchGroup()
        
        loadNFT(with: dispatchGroup)
        loadProfile(with: dispatchGroup)
        
        dispatchGroup.notify(queue: .main) {
            self.view?.updateUI()
            self.view?.hideLoading()
        }
    }
    
    private func loadNFT(with dispatchGroup: DispatchGroup) {
        selectedCollection.nfts.forEach { id in
            dispatchGroup.enter()
            servicesAssembly.nftService.loadNft(id: id) { [weak self] result in
                switch result {
                case .success(let nft):
                    self?.nftArray.append(nft)
                case .failure(_):
                    self?.view?.showError(ErrorModel(message: "Ошибка получения данных", actionText: "Попробовать снова", action: { [weak self] in
                        self?.loadData()
                    }))
                }
                dispatchGroup.leave()
            }
        }
    }
    
    private func loadProfile(with dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()
        servicesAssembly.userProfileService.fetchUserProfile { [weak self] result in
            switch result {
            case .success(let userProfile):
                self?.userProfile = userProfile
            case .failure(_):
                self?.view?.showError(ErrorModel(message: "Ошибка получения данных", actionText: "Попробовать снова", action: { [weak self] in
                    self?.loadData()
                }))
            }
            dispatchGroup.leave()
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
    
    func didTapLikeButton(indexPath: IndexPath) {
        guard indexPath.row < nftArray.count,
        let userProfile = userProfile else {
            return
        }
        let currentNft = nftArray[indexPath.row]
        let isLiked = userProfile.likes.contains(currentNft.id)
        var userProfileLikes = userProfile.likes
        
        if isLiked {
            userProfileLikes.removeAll {$0 == currentNft.id}
        } else {
            userProfileLikes.append(currentNft.id)
        }
        
        let resultString = userProfileLikes.joined(separator: ", ")
        servicesAssembly.userProfileService.changeLike(newNftLikes: resultString) { [weak self] result in
            switch result {
            case .success(let userProfile):
                self?.userProfile = userProfile
                self?.view?.updateCell(cellIndexPath: indexPath)
            case .failure(_):
                self?.view?.showError(ErrorModel(message: "Ошибка получения данных", actionText: "Я понял(", action: {
        
                }))
            }
        }
    }
}
