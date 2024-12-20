import Foundation
import UIKit
import ProgressHUD

protocol CartView: UIViewController, LoadingView {
    func switchCollectionViewState(isEmptyList: Bool)
    func updateCollectionView()
    func performBatchUpdate(deletionAt indexPath: IndexPath, completion: @escaping () -> Void)
    func performBatchUpdate(moveFrom fromIndexPaths: [IndexPath], to toIndexPaths: [IndexPath], completion: @escaping () -> Void)
    func configureTotalCost(totalPrice: Double, nftsCount: Int)
    func setupNavigationBarForNextScreen()
    func showAlert(_ alert: AlertViewModel)
}

final class CartViewController: UIViewController, CartView{
    // MARK: - Public Properties
    let presenter: CartPresenter
    
    var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    lazy var window: UIWindow? = {
        return UIApplication.shared.windows.first
    }()
    
    enum Constants {
        static let filterButtonIcon = "filterButtonIcon"
            static let deleteNftIcon = "deleteNftIcon"
            static let nftStubImage = "nftStubImage"
            static let costString = NSLocalizedString("Cart_Cost", comment: "Label for displaying the cost")
            static let payButtonString = NSLocalizedString("Cart_PayButton", comment: "Title for the pay button")
            static let emptyCartLabelString = NSLocalizedString("Cart_EmptyLabel", comment: "Label shown when the cart is empty")
    }
    
    // MARK: - Private Properties
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var emptyCartLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.bold17
        label.textColor = UIColor.dynamicBlack
        return label
    }()
    
    private let itemsPerRow: CGFloat = 1
    private let sectionInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    private let interItemSpacing: CGFloat = 0
    private var cellHeight: CGFloat = 0
    
    private lazy var buttonPanelView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = UIColor.dynamicLightGray

        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return view
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.dynamicBlack
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.bold17

        button.setTitleColor(UIColor.dynamicWhite, for: .normal)

        return button
    }()
    
    private lazy var nftCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.regular15
        label.textColor = UIColor.dynamicBlack
        return label
    }()
    
    private lazy var totalCostLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.bold17
        label.textColor = UIColor.yaGreenUniversal
        return label
    }()

    // MARK: - Initializers
    init(presenter: CartPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setupLoadingView()
        setupNavigationBar()
        setupCollectionView()
        setupButtonPanel()
        
        presenter.viewDidLoad()
        
        let costLabel = Bundle.main.localizedString(forKey: "Cart_Cost", value: nil, table: nil)
        print("Localized cost label:", costLabel)
        
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - Actions
    @objc private func filterButtonTapped() {
        presenter.filterButtonTapped()
    }
    
    @objc private func payButtonTapped() {
        presenter.payButtonTapped()
    }
    
    // MARK: - Public Methods
    func switchCollectionViewState(isEmptyList: Bool) {
        collectionView.isHidden = isEmptyList
        buttonPanelView.isHidden = isEmptyList
        navigationController?.navigationBar.isHidden = isEmptyList
        emptyStateView.isHidden = !isEmptyList
    }
    
    func configureTotalCost(totalPrice: Double, nftsCount: Int) {
        totalCostLabel.text = "\((totalPrice * 100).rounded()/100) ETH"
        nftCountLabel.text = "\(nftsCount) NFT"
    }
    
    func updateCollectionView() {
        collectionView.reloadData()
    }
    
    func performBatchUpdate(deletionAt indexPath: IndexPath, completion: @escaping () -> Void) {
        collectionView.performBatchUpdates({
            self.collectionView.deleteItems(at: [indexPath])
        }, completion: { _ in
            completion()
        })
    }
    
    func performBatchUpdate(moveFrom fromIndexPaths: [IndexPath], to toIndexPaths: [IndexPath], completion: @escaping () -> Void) {
        collectionView.performBatchUpdates({
            for (fromIndexPath, toIndexPath) in zip(fromIndexPaths, toIndexPaths) {
                self.collectionView.moveItem(at: fromIndexPath, to: toIndexPath)
            }
        }, completion: {_ in
            completion()
        })
    }
    
    func setupNavigationBarForNextScreen() {
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButton
        navigationController?.navigationBar.tintColor = UIColor.dynamicBlack
    }
    
    func showAlert(_ alert: AlertViewModel) {
        let alertController = alert.createAlertController()
        self.present(alertController, animated: true)
    }
    
    // MARK: - Private Methods - Верстка
    private func setupLoadingView() {
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.shadowColor = nil

            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance

            navigationController?.navigationBar.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        
        let filterButton = UIBarButtonItem(image: UIImage(named: Constants.filterButtonIcon), style: .done, target: self, action: #selector(filterButtonTapped))
        filterButton.tintColor = UIColor.dynamicBlack
        
        navigationItem.rightBarButtonItem = filterButton
    }

    private func setupCollectionView() {
        collectionView.register(CartItemCell.self, forCellWithReuseIdentifier: CartItemCell.cellIdentifier)
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        emptyCartLabel.text = Constants.emptyCartLabelString
        emptyStateView.addSubview(emptyCartLabel)
        
        NSLayoutConstraint.activate([
            emptyCartLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyCartLabel.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor),
        ])
        
        view.addSubview(emptyStateView)
        emptyStateView.isHidden = true
        
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            emptyStateView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupButtonPanel() {
        payButton.setTitle(Constants.payButtonString, for: .normal)
        payButton.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        buttonPanelView.isHidden = true
        buttonPanelView.addSubview(payButton)
        
        NSLayoutConstraint.activate([
            payButton.topAnchor.constraint(equalTo: buttonPanelView.topAnchor, constant: 16),
            payButton.bottomAnchor.constraint(equalTo: buttonPanelView.bottomAnchor, constant: -16),
            payButton.leadingAnchor.constraint(greaterThanOrEqualTo: buttonPanelView.leadingAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: buttonPanelView.trailingAnchor, constant: -16),
            payButton.widthAnchor.constraint(equalToConstant: 240 * ScreenSizeHelper.getViewMultiplier())
        ])
    
        buttonPanelView.addSubview(nftCountLabel)
        
        NSLayoutConstraint.activate([
            nftCountLabel.topAnchor.constraint(equalTo: buttonPanelView.topAnchor, constant: 16),
            nftCountLabel.bottomAnchor.constraint(lessThanOrEqualTo: buttonPanelView.bottomAnchor, constant: -16),
            nftCountLabel.leadingAnchor.constraint(equalTo: buttonPanelView.leadingAnchor, constant: 16),
            nftCountLabel.trailingAnchor.constraint(greaterThanOrEqualTo: payButton.trailingAnchor, constant: -16)
        ])
        
        buttonPanelView.addSubview(totalCostLabel)
        
        NSLayoutConstraint.activate([
            totalCostLabel.topAnchor.constraint(greaterThanOrEqualTo: nftCountLabel.bottomAnchor, constant: 2),
            totalCostLabel.bottomAnchor.constraint(equalTo: buttonPanelView.bottomAnchor, constant: -16),
            totalCostLabel.leadingAnchor.constraint(equalTo: buttonPanelView.leadingAnchor, constant: 16),
            totalCostLabel.trailingAnchor.constraint(greaterThanOrEqualTo: payButton.trailingAnchor, constant: -16)
        ])
        
        view.addSubview(buttonPanelView)
        
        NSLayoutConstraint.activate([
            buttonPanelView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonPanelView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            buttonPanelView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            buttonPanelView.heightAnchor.constraint(equalToConstant: 76)
        ])
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension CartViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getNFTs()?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CartItemCell.cellIdentifier, for: indexPath) as? CartItemCell {
            guard let nfts = presenter.getNFTs() else {return cell}
            cell.configure(with: nfts[indexPath.row], stubImage: UIImage(named: Constants.nftStubImage))
            cell.delegate = self
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = view.frame.width
        let paddingSpace = sectionInsets.left + sectionInsets.right + interItemSpacing * (itemsPerRow - 1)
        let availableWidth = screenWidth - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = widthPerItem * (140 / 375)
        cellHeight = heightPerItem
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
}

//MARK: CartItemCellDelegate
extension CartViewController: CartItemCellDelegate {
    func didTapButton(in cell: CartItemCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            presenter.removeButtonTapped(at: indexPath)
        }
    }
}
