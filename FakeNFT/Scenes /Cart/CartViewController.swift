//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Дима on 11.10.2024.
//

import Foundation
import UIKit

protocol CartView: UIViewController {
    func switchCollectionViewState(isEmptyList: Bool)
    func updateCollectionView()
    func configureTotalCost(totalPrice: Double, nftsCount: Int)
}

final class CartViewController: UIViewController, CartView {
    let presenter: CartPresenter
    
    private let screenWidth = UIScreen.main.bounds.width
    private var multiplierForView: CGFloat = 0
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let emptyCartLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.bold17
        label.textColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.yaBlackDark : UIColor.yaBlackLight
        }
        return label
    }()
    
    private let cellIdentifier = "CartItemCell"
    private let itemsPerRow: CGFloat = 1
    private let sectionInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    private let interItemSpacing: CGFloat = 0
    private var cellHeight: CGFloat = 0
    
    private let buttonPanelView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.yaLightGrayDark : UIColor.yaLightGrayLight
        }

        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return view
    }()
    
    private let payButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.yaBlackDark : UIColor.yaBlackLight
        }
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.bold17

        button.setTitleColor(UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.yaWhiteDark : UIColor.yaWhiteLight
        }, for: .normal)

        return button
    }()
    
    private let nftCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.regular15
        label.textColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.yaBlackDark : UIColor.yaBlackLight
        }
        return label
    }()
    
    private let totalCostLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.bold17
        label.textColor = UIColor.yaGreenUniversal
        return label
    }()
    
    enum Constants {
        static let filterButtonIcon = "filterButtonIcon"
        static let deleteNftIcon = "deleteNftIcon"
        static let nftStubImage = "nftStubImage"
        static let costString = "Цена"
        static let payButtonString = "К оплате"
        static let emptyCartLabelString = "Корзина пуста"
    }

    init(presenter: CartPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        multiplierForView = screenWidth / 375.0
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setupNavigationBar()
        setupCollectionView()
        setupButtonPanel()
        
        presenter.viewDidLoad()
        
        view.backgroundColor = .systemBackground
    }
    
    //MARK: Public
    func switchCollectionViewState(isEmptyList: Bool) {
        collectionView.isHidden = isEmptyList
        buttonPanelView.isHidden = isEmptyList
        navigationController?.navigationBar.isHidden = isEmptyList
        emptyStateView.isHidden = !isEmptyList
    }
    
    func configureTotalCost(totalPrice: Double, nftsCount: Int) {
        totalCostLabel.text = "\(totalPrice) ETH"
        nftCountLabel.text = "\(nftsCount) NFT"
    }
    
    func updateCollectionView() {
        collectionView.reloadData()
    }
    
    //MARK: Верстка
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.shadowColor = nil

            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance

            // Adjust the content inset if needed
            navigationController?.navigationBar.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        
        let filterButton = UIBarButtonItem(image: UIImage(named: Constants.filterButtonIcon), style: .done, target: self, action: #selector(filterButtonTapped))
        filterButton.tintColor = .black
        
        navigationItem.rightBarButtonItem = filterButton
    }

    private func setupCollectionView() {
        collectionView.register(CartItemCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
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
        buttonPanelView.addSubview(payButton)
        
        NSLayoutConstraint.activate([
            payButton.topAnchor.constraint(equalTo: buttonPanelView.topAnchor, constant: 16),
            payButton.bottomAnchor.constraint(equalTo: buttonPanelView.bottomAnchor, constant: -16),
            payButton.leadingAnchor.constraint(greaterThanOrEqualTo: buttonPanelView.leadingAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: buttonPanelView.trailingAnchor, constant: -16),
            payButton.widthAnchor.constraint(equalToConstant: 240 * multiplierForView)
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
    
    
    
    //MARK: Кнопки
    @objc private func filterButtonTapped() {
        // Handle filter button action
    }
    
    //MARK: Private

}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension CartViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getNFTs()?.count ?? 0 // Sample item count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CartItemCell
        guard let nfts = presenter.getNFTs() else {return cell}
        cell.configure(with: nfts[indexPath.row], stubImage: UIImage(named: Constants.nftStubImage))
        return cell
    }
    
    // Set the cell size to match the width of the screen with the aspect ratio of 375:140
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = view.frame.width
        let paddingSpace = sectionInsets.left + sectionInsets.right + interItemSpacing * (itemsPerRow - 1)
        let availableWidth = screenWidth - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = widthPerItem * (140 / 375)
        cellHeight = heightPerItem
        print(cellHeight, widthPerItem)
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
}
