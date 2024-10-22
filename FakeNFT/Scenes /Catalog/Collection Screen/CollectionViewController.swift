//  Created by Artem Morozov on 14.10.2024.


import UIKit

protocol CollectionViewControllerProtocol: AnyObject, ErrorView, LoadingView {
    func updateUI()
    func updateCell(cellIndexPath: IndexPath)
}

final class CollectionViewController: UIViewController {
    
    private let presenter: CollectionPresenter
    
    var activityIndicator = UIActivityIndicatorView()
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    private lazy var backButton = UIButton(type: .system)
    private lazy var collectionImageView = UIImageView()
    private lazy var collectionNameLabel = UILabel()
    private lazy var stackViewAuthorLabels = UIStackView()
    private lazy var collectionAuthorLabel = UILabel()
    private lazy var collectionAuthorNameLinkL = UILabel()
    private lazy var collectionDescriptionTextView = UITextView()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.backgroundColor = .systemBackground
        collectionView.isScrollEnabled = false
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        return collectionView
    }()
    
    private let geometricParams = GeometricParams(cellCount: 3, leftInset: 16, rightInset: 16, cellSpacing: 9)
    
    // MARK: - Init
    
    init(presenter: CollectionPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        configureUI()
    }
    
    // MARK: - private functions
    
}

extension CollectionViewController: CollectionViewControllerProtocol {
    func updateUI() {
        collectionView.reloadData()
        let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
        collectionView.heightAnchor.constraint(equalToConstant: contentHeight).isActive = true
    }
    
    func updateCell(cellIndexPath: IndexPath) {
        collectionView.reloadItems(at: [cellIndexPath])
    }
}

//MARK: CollectionViewCellDelegate func cart and like

extension CollectionViewController: CollectionViewCellDelegate {
    func didTapCartButton(in cell: CollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        presenter.didTapCartButton(indexPath: indexPath)
    }
    
    func didTapLikeButton(in cell: CollectionViewCell) {
        print("Нажали Like")
    }
    
    
}

// MARK: - UICollectionViewDataSource func

extension CollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.nftArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath)
        guard let collectionCell = cell as? CollectionViewCell else {
            return CollectionViewCell()
        }
        collectionCell.delegate = self
        collectionCell.configureCell(cellViewModel: presenter.cellViewModels[indexPath.row])
        return collectionCell
    }
}

// MARK: - UICollectionViewDelegate func

extension CollectionViewController: UICollectionViewDelegate {

}

// MARK: UICollectionViewDelegateFlowLayout func

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - geometricParams.paddingWidth
        let cellWidth = availableWidth / CGFloat(geometricParams.cellCount)
        return CGSize(width: cellWidth, height: cellWidth * 1.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        geometricParams.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: geometricParams.leftInset, bottom: 24, right: geometricParams.rightInset)
    }
}

// MARK: - ConfigureUI

private extension CollectionViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        configureScrollView()
        configureCollectionImageView()
        configureBackButton()
        configureCollectionNameLabel()
        configureCollectionAuthorLabel()
        configureCollectionDescriptionTextView()
        configureCollectionView()
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.backgroundColor = .systemBackground
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
    
    func configureCollectionImageView() {
        collectionImageView.clipsToBounds = true
        collectionImageView.layer.cornerRadius = 12
        collectionImageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        collectionImageView.contentMode = .scaleAspectFill
        collectionImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(collectionImageView)
        
        NSLayoutConstraint.activate([
            collectionImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionImageView.heightAnchor.constraint(equalToConstant: 310)
        ])
        
        guard let url = URL(string: presenter.selectedCollection.cover) else {return}
        collectionImageView.kf.setImage(with: url)
    }
    
    func configureBackButton() {
        backButton.setImage(UIImage(named: "backButton"), for: .normal)
        backButton.tintColor = UIColor.segmentActive
        backButton.addTarget(self, action: #selector(backButtonDidTapped), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    @objc func backButtonDidTapped() {
        self.dismiss(animated: true)
    }
    
    func configureCollectionNameLabel() {
        collectionNameLabel.text = presenter.selectedCollection.name
        collectionNameLabel.textColor = UIColor.segmentActive
        collectionNameLabel.font = UIFont.bold22
        collectionNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(collectionNameLabel)
        
        NSLayoutConstraint.activate([
            collectionNameLabel.topAnchor.constraint(equalTo: collectionImageView.bottomAnchor, constant: 13),
            collectionNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }
    
    func configureCollectionAuthorLabel() {
        collectionAuthorNameLinkL.isUserInteractionEnabled = true
        collectionAuthorNameLinkL.textColor = UIColor.yaBlueUniversal
        collectionAuthorNameLinkL.font = UIFont.regular13
        collectionAuthorNameLinkL.translatesAutoresizingMaskIntoConstraints = false
        collectionAuthorNameLinkL.text = presenter.selectedCollection.author
        
        collectionAuthorLabel.textColor = UIColor.segmentActive
        collectionAuthorLabel.font = UIFont.regular13
        collectionAuthorLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionAuthorLabel.text = "Автор коллекции:"
        collectionAuthorLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openAuthorWebView))
        collectionAuthorNameLinkL.addGestureRecognizer(tapGesture)
        
        stackViewAuthorLabels = UIStackView(arrangedSubviews: [collectionAuthorLabel, collectionAuthorNameLinkL])
        stackViewAuthorLabels.axis = .horizontal
        stackViewAuthorLabels.alignment = .leading
        stackViewAuthorLabels.spacing = 2
        stackViewAuthorLabels.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackViewAuthorLabels)
        
        NSLayoutConstraint.activate([
            stackViewAuthorLabels.topAnchor.constraint(equalTo: collectionNameLabel.bottomAnchor, constant: 13),
            stackViewAuthorLabels.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackViewAuthorLabels.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }
    
    @objc func openAuthorWebView() {
        let webViewPresenter: WebViewPresenter = WebViewPresenterImpl()
        let webViewController = WebViewController(presenter: webViewPresenter)
        webViewPresenter.view = webViewController
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
    func configureCollectionDescriptionTextView() {
        collectionDescriptionTextView.text = presenter.selectedCollection.description
        collectionDescriptionTextView.isScrollEnabled = false
        collectionDescriptionTextView.backgroundColor = .systemBackground
        collectionDescriptionTextView.font = UIFont.regular13
        collectionDescriptionTextView.textColor = UIColor.segmentActive
        collectionDescriptionTextView.textContainer.lineFragmentPadding = 0
        collectionDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(collectionDescriptionTextView)
        
        NSLayoutConstraint.activate([
            collectionDescriptionTextView.topAnchor.constraint(equalTo: stackViewAuthorLabels.bottomAnchor),
            collectionDescriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionDescriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        ])
    }
    
    func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: collectionDescriptionTextView.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
