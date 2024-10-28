import Foundation
import UIKit

protocol ChooseCurrencyViewController: UIViewController, LoadingView {
    func updateCollectionView()
    func toogleSelectAtCell(at indexPath: IndexPath, isSelected: Bool)
    func updatePayButtonState(_ isCurrencySelected: Bool)
    func showAlert(_ alert: AlertViewModel)
    func configure(nftLargeImageURL: URL)
}

final class ChooseCurrencyViewControllerImpl: UIViewController, ChooseCurrencyViewController {
    // MARK: - Public Properties
    var presenter: ChooseCurrencyPresenter
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    lazy var window: UIWindow? = {
        return UIApplication.shared.windows.first
    }()
    
    enum Constants: String {
        case payScreenTitle = "Выбор способа оплаты"
        case userAgreementText = "Совершая покупку, вы соглашаетесь с условиями Пользовательского соглашения"
        case payButtonText = "Оплатить"
    }
    
    // MARK: - Private Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.bold17
        label.textColor = UIColor.dynamicBlack
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 7
            layout.minimumLineSpacing = 7

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var lastSelectedCell: IndexPath?

    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    private let interItemSpacing: CGFloat = 7
    private let verticalItemSpacing: CGFloat = 7
    private let itemAspectRatio: CGFloat = 46 / 168
    
    private let userAgreementPanelView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = UIColor.dynamicLightGray

        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return view
    }()
    
    private lazy var userAgreementTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear

        textView.dataDetectorTypes = []

        return textView
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
    
    // MARK: - Initializers
    init(presenter: ChooseCurrencyPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setupLoadingView()
        setupNavigationBarTitle()
        setupCollectionView()
        setupButtonPanel()
        
        updatePayButtonState(false)
        
        presenter.viewDidLoad()
    }
    
    // MARK: - Actions
    @objc private func didPayButtonTapped() {
        presenter.payOrder(with: Array(CartStore.nftsInCart))
    }
    
    // MARK: - Public Methods
    func configure(nftLargeImageURL: URL) {
        presenter.nftLargeImageURL = nftLargeImageURL
    }
    
    func updateCollectionView() {
        collectionView.reloadData()
    }
    
    func toogleSelectAtCell(at indexPath: IndexPath, isSelected: Bool) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CurrencyCell else {return}
        cell.toggleSelectState(isSelected)
    }
    
    func showAlert(_ alert: AlertViewModel) {
        let alertController = alert.createAlertController()
        self.present(alertController, animated: true)
    }
    
    func updatePayButtonState(_ isCurrencySelected: Bool) {
        payButton.isEnabled = isCurrencySelected ? true : false
        payButton.backgroundColor = isCurrencySelected ? UIColor.dynamicBlack.withAlphaComponent(1.0) : UIColor.dynamicBlack.withAlphaComponent(0.5)
    }
    
    // MARK: - Private Methods - Верстка
    private func setupNavigationBarTitle() {
        self.title = Constants.payScreenTitle.rawValue
    }
    
    private func setupLoadingView() {
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.register(CurrencyCell.self, forCellWithReuseIdentifier: CurrencyCell.reuseIdentifier)
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupButtonPanel() {
        view.addSubview(userAgreementPanelView)
        
        NSLayoutConstraint.activate([
            userAgreementPanelView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            userAgreementPanelView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            userAgreementPanelView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            userAgreementPanelView.heightAnchor.constraint(equalToConstant: 184)
        ])
    
        userAgreementTextView.attributedText = makeUserAgreementLabelWithLink()
        userAgreementPanelView.addSubview(userAgreementTextView)
        
        NSLayoutConstraint.activate([
            userAgreementTextView.bottomAnchor.constraint(equalTo: userAgreementPanelView.bottomAnchor, constant: -4),
            userAgreementTextView.leadingAnchor.constraint(equalTo: userAgreementPanelView.leadingAnchor, constant: 16),
            userAgreementTextView.trailingAnchor.constraint(equalTo: userAgreementPanelView.trailingAnchor, constant: -16),
            userAgreementTextView.topAnchor.constraint(equalTo: userAgreementPanelView.topAnchor, constant: 16)
        ])
        
        userAgreementPanelView.addSubview(payButton)
        payButton.setTitle(Constants.payButtonText.rawValue, for: .normal)
        payButton.addTarget(self, action: #selector(didPayButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            payButton.bottomAnchor.constraint(equalTo: userAgreementPanelView.bottomAnchor, constant: -48),
            payButton.leadingAnchor.constraint(equalTo: userAgreementPanelView.leadingAnchor, constant: 12),
            payButton.trailingAnchor.constraint(equalTo: userAgreementPanelView.trailingAnchor, constant: -12),
            payButton.topAnchor.constraint(greaterThanOrEqualTo: userAgreementPanelView.topAnchor, constant: 16),
            payButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
    }
    
    // MARK: - Private Methods
    private func makeUserAgreementLabelWithLink() -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: Constants.userAgreementText.rawValue)
        
        let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
        
        let font = UIFont.regular13
        attributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: attributedString.length))
        
        attributedString.addAttribute(.foregroundColor, value: UIColor.dynamicBlack, range: NSRange(location: 0, length: attributedString.length))
        
        let linkRange = (Constants.userAgreementText.rawValue as NSString).range(of: "Пользовательского соглашения")
        
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.link, value: "https://www.example.com", range: linkRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.yaBlueUniversal, range: linkRange)

        return attributedString
    }
}

//MARK: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ChooseCurrencyViewControllerImpl: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.currencies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrencyCell.reuseIdentifier, for: indexPath) as? CurrencyCell {
            cell.configure(with: presenter.currencies[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left + sectionInsets.right + interItemSpacing * (itemsPerRow - 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = widthPerItem * itemAspectRatio
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return verticalItemSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Выбрана ячейка под индексом: \(indexPath.row)")
        if let lastSelectedCell {
            toogleSelectAtCell(at: lastSelectedCell, isSelected: false)
        }
        presenter.currencyDidSelect(at: indexPath)
        self.lastSelectedCell = indexPath
        
    }
}
