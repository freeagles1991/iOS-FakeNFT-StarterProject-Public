import UIKit

final class TestCatalogViewController: UIViewController, LoadingView {
    lazy var window: UIWindow? = {
        return UIApplication.shared.windows.first
    }()
    
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    let servicesAssembly: ServicesAssembly
    let testNftButton = UIButton()
    let raiting = StarRatingView()
    
    private let testNFTs: [String] = [
    "1464520d-1659-4055-8a79-4593b9569e48",
    "b2f44171-7dcd-46d7-a6d3-e2109aacf520",
    "fa03574c-9067-45ad-9379-e3ed2d70df78"
    ]
    
    private let testNFTsInCart: [String] = [
    "1464520d-1659-4055-8a79-4593b9569e48",
    "b2f44171-7dcd-46d7-a6d3-e2109aacf520"
    ]

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
        
        //"Добавляем" в корзину nft для тестов
        addNftToCart(nftIDs: testNFTsInCart)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLoadingView()

        view.backgroundColor = .systemBackground
        raiting.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(testNftButton)
        view.addSubview(raiting)
        testNftButton.constraintCenters(to: view)
        
        raiting.topAnchor.constraint(equalTo: testNftButton.bottomAnchor, constant: 18).isActive = true
            raiting.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        raiting.rating = 80
        testNftButton.setTitle(Constants.openNftTitle, for: .normal)
        testNftButton.addTarget(self, action: #selector(showNft), for: .touchUpInside)
        testNftButton.setTitleColor(.systemBlue, for: .normal)
        
        loadTestNfts()
    }

    @objc
    func showNft() {
        let assembly = NftDetailAssembly(servicesAssembler: servicesAssembly)
        let nftInput = NftDetailInput(id: Constants.testNftId)
        let nftViewController = assembly.build(with: nftInput)
        present(nftViewController, animated: true)
    }
    
    // MARK: - Private Methods
    private func setupLoadingView() {
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func addNftToCart(nftIDs: [String]) {
        CartStore.nftsInCart.formUnion(nftIDs)
    }
    
    private func loadTestNfts() {
        showLoading()
        loadNfts(byIDs: testNFTs) { [weak self] in
            self?.hideLoading()
        }
    }
    
    //Этот метод нужен только для тестирования, загружает несколько nft по списку как будто из каталога
    private func loadNfts(byIDs ids: [String], completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        ids.forEach { id in
            dispatchGroup.enter()
            servicesAssembly.nftService.loadNft(id: id) { result in
                switch result {
                case .success(let nft):
                    print("Loaded NFT: \(nft)")
                case .failure(let error):
                    print("Failed to load NFT: \(error.localizedDescription)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
}

private enum Constants {
    static let openNftTitle = NSLocalizedString("Catalog.openNft", comment: "")
    static let testNftId = "7773e33c-ec15-4230-a102-92426a3a6d5a"
}
