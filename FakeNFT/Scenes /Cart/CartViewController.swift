//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Дима on 11.10.2024.
//

import Foundation
import UIKit

protocol CartView: UIViewController {
    
}

final class CartViewController: UIViewController, CartView {
    let presenter: CartPresenter
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let cellIdentifier = "CartItemCell"
    private let itemsPerRow: CGFloat = 1
    private let sectionInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    private let interItemSpacing: CGFloat = 0
    private var cellHeight: CGFloat = 0
    
    enum Constants {
        static var filterButtonIcon = "filterButtonIcon"
        static var deleteNftIcon = "deleteNftIcon"
        static var nftStubImage = "nftStubImage"
        static var costString = "Цена"
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
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setupNavigationBar()
        setupCollectionView()
        
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavigationBar() {
        let filterButton = UIBarButtonItem(image: UIImage(named: Constants.filterButtonIcon), style: .plain, target: self, action: #selector(filterButtonTapped))
        navigationItem.rightBarButtonItem = filterButton
    }

    @objc private func filterButtonTapped() {
        // Handle filter button action
    }

    private func setupCollectionView() {
        collectionView.register(CartItemCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension CartViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10 // Sample item count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CartItemCell
        cell.configure(with: Nft(), stubImage: UIImage(named: Constants.nftStubImage))
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
