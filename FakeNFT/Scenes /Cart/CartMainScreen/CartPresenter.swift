import Foundation
import Kingfisher

protocol CartPresenter {
    func getNFTs() -> [Nft]?
    func viewDidLoad()
    func filterButtonTapped()
    func payButtonTapped()
    func removeButtonTapped(at indexPath: IndexPath)
}

final class CartPresenterImpl: CartPresenter, SortingDelegate {
    
    // MARK: - Public Properties
    weak var view: CartView?
    var serviceAssembler: ServicesAssembly
    
    // MARK: - Private Properties
    private let nftService: NftService
    
    private var nfts: [Nft] = [] {
        didSet {
            guard let view else {return}
            view.switchCollectionViewState(isEmptyList: nfts.isEmpty)
            view.configureTotalCost(totalPrice: getNftsTotalPrice(), nftsCount: self.nfts.count)
            
        }
    }
    
    // MARK: - Initializers
    init(nftService: NftService, serviceAssembler: ServicesAssembly) {
        self.serviceAssembler = serviceAssembler
        self.nftService = nftService
        
        NotificationCenter.default.addObserver(self, selector: #selector(cartDidChange), name: CartStore.cartChangedNotification, object: nil)
    }
    
    // MARK: - Actions
    @objc private func cartDidChange() {
        updateCart()
    }
    
    // MARK: - Public Methods
    func viewDidLoad() {
        updateCart()
    }
    
    func getNFTs() -> [Nft]? {
        return nfts
    }
    
    func filterButtonTapped() {
        guard let view, let alertViewModel = SortingHelper.makeSortingAlertViewModel(sortingDelegate: self) else {return}
        view.showAlert(alertViewModel)
    }
    
    func payButtonTapped() {
        let payAssembly = ChooseCurrencyAssembly(servicesAssembler: serviceAssembler)
        guard let payViewController = payAssembly.build() as? ChooseCurrencyViewController else {return}
        payViewController.hidesBottomBarWhenPushed = true

        guard let view else { return }
        view.setupNavigationBarForNextScreen()
        view.navigationController?.pushViewController(payViewController, animated: true)
    }
    
    func removeButtonTapped(at indexPath: IndexPath) {
        guard let view else {return}
        
        let removeFromCartAssembly = RemoveFromCartAssembly()
        guard let removeFromCartVC = removeFromCartAssembly.build() as? RemoveFromCartViewController else { return }
        removeFromCartVC.modalPresentationStyle = .overFullScreen
        removeFromCartVC.modalTransitionStyle = .crossDissolve
        
        removeFromCartVC.configureScreen(with: self.nfts[indexPath.row])

        removeFromCartVC.onConfirm = { [weak self] in
            guard let self else {return}
            
            let nftID = self.nfts[indexPath.row].id
            
            removeFromNFTs(at: indexPath.row)
            
            view.performBatchUpdate(deletionAt: indexPath) { [weak self] in
                guard let self else {return}
                self.deleteNftFromCart(with: nftID)
            }
        }
        
        view.present(removeFromCartVC, animated: true, completion: nil)
    }
    
    func sortNFTs(by sortingMethod: SortingMethod) {
        let originalData = nfts

        nfts.sort { $0.compare(with: $1, by: sortingMethod) }
        
        var fromIndexPaths: [IndexPath] = []
        var toIndexPaths: [IndexPath] = []
        
        for (newIndex, nft) in nfts.enumerated() {
            if let oldIndex = originalData.firstIndex(where: { $0.id == nft.id }), oldIndex != newIndex {
                fromIndexPaths.append(IndexPath(item: oldIndex, section: 0))
                toIndexPaths.append(IndexPath(item: newIndex, section: 0))
            }
        }
        
        if fromIndexPaths == toIndexPaths {
            return
        }
        
        view?.performBatchUpdate(moveFrom: fromIndexPaths, to: toIndexPaths) { }
    }
    
    //MARK: Private
    private func updateNfts(completion: @escaping ()-> Void) {
        getNFTsInCartByID(nftsInCart: Array(CartStore.nftsInCart),completion: { nfts in
            self.nfts = nfts
            completion()
        } )
    }
    
    private func removeFromNFTs(at index: Int) {
        nfts.remove(at: index)
    }
    
    private func deleteNftFromCart(with id: String) {
        CartStore.nftsInCart.remove(id)
    }
    
    private func getNFTsInCartByID(nftsInCart: [String], completion: @escaping ([Nft]) -> Void) {
        var nfts: [Nft] = []
        let dispatchGroup = DispatchGroup()
        
        for id in nftsInCart {
            dispatchGroup.enter()
            
            nftService.loadNft(id: id) { [weak self] result in
                switch result {
                case .success(let nft):
                    nfts.append(nft)
                    print("CartPresenterImpl: Успешно загружен nft \(nft.name), ID = \(nft.id)")
                case .failure(let error):
                    print("CartPresenterImpl: Ошибка при загрузке nft \(error)")
                    guard let self, let view = self.view else {return}
                    
                    let action = AlertViewModel.AlertAction(title: "Попробовать снова", style: .default) {
                        self.updateNfts() { [weak self] in
                            guard let self else {return}
                            view.switchCollectionViewState(isEmptyList: nfts.isEmpty)
                            view.updateCollectionView()
                            view.configureTotalCost(totalPrice: getNftsTotalPrice(), nftsCount: self.nfts.count)
                        }
                    }
                    
                    let alert = AlertViewModel(title: "Упс", message: "Загрузка не удалась", actions: [action], preferredStyle: .alert)
                    view.showAlert(alert)
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(nfts)
        }
    }
    
    private func loadNftLargeImage() {
        guard let imageUrlLight = nfts.first?.images[2],
              let imageUrlDark = nfts.first?.images[1]
        else { return }
        
        let imageURL = view?.traitCollection.userInterfaceStyle == .dark ? imageUrlDark : imageUrlLight
        
        CartStore.nftLargeImageURL = imageURL
        ImagePrefetcher(urls: [imageURL]).start()
    }
    
    private func updateCart() {
        self.updateNfts() { [weak self] in
            guard let self, let view else { return }
            self.loadNftLargeImage()
            view.switchCollectionViewState(isEmptyList: nfts.isEmpty)
            view.updateCollectionView()
            view.configureTotalCost(totalPrice: getNftsTotalPrice(), nftsCount: self.nfts.count)
            view.hideLoading()
        }
    }
    
    private func getNftsTotalPrice() -> Double{
        var price: Double = 0
        for nft in nfts {
            price = price + nft.price
        }
        return price
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
