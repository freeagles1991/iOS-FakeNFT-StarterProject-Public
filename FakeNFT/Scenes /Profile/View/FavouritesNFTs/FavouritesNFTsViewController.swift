//
//  FavouritesNFTsViewController.swift
//  FakeNFT
//
//  Created by Артур  Арсланов on 13.10.2024.
//

import UIKit

final class FavouritesNFTsViewController: UIViewController {
    private var favoriteNFTs: [NFT] = []
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadFavoriteNFTs()
    }
    
    private func loadFavoriteNFTs() {
        if favoriteNFTs.isEmpty {
            collectionView.setEmptyMessage("У вас еще нет избранных NFT.")
        } else {
            collectionView.restore()
        }
        collectionView.reloadData()
    }
    
    private func removeNFTFromFavorites(at indexPath: IndexPath) {
        favoriteNFTs.remove(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])
        
        if favoriteNFTs.isEmpty {
            collectionView.setEmptyMessage("У вас еще нет избранных NFT.")
        }
    }
    
    private  func setupUI() {
        title = "Избранные NFT"
        view.backgroundColor = .systemBackground
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.register(NFTCollectionViewCell.self, forCellWithReuseIdentifier: NFTTableViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension FavouritesNFTsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favoriteNFTs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTCollectionViewCell.identifier, for: indexPath) as? NFTCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let nft = favoriteNFTs[indexPath.item]
        cell.configure(with: nft)
        cell.onHeartButtonTapped = { [weak self] in
            self?.removeNFTFromFavorites(at: indexPath)
        }
        
        return cell
    }
    
    
}

extension FavouritesNFTsViewController: UICollectionViewDelegate {
    
}

extension UICollectionView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.numberOfLines = 1
        messageLabel.textAlignment = .center
        messageLabel.font = .bold17
        messageLabel.textColor = .segmentActive
        
        self.backgroundView = messageLabel
    }
    
    func restore() {
        backgroundView = nil
    }
}
