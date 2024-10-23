//
//  FavouritesNFTsViewController.swift
//  FakeNFT
//
//  Created by Артур  Арсланов on 13.10.2024.
//

import UIKit
import ProgressHUD

final class FavouritesNFTsViewController: UIViewController {
    private var favoriteNFTs: [Nft] = []
    private var presenter : FavouritesNFTsPresenter?
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    init(presenter: FavouritesNFTsPresenter?) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(presenter == nil)
        presenter?.viewDidLoad()
        setupUI()
    
    }
    
    
    private  func setupUI() {
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
//        cell.onHeartButtonTapped = { [weak self] in
//
//        }
        
        return cell
    }
    
    
}

extension FavouritesNFTsViewController: UICollectionViewDelegate {
    
}

extension FavouritesNFTsViewController: FavouritesViewProtocol {
    func showLoadingIndicator() {
        ProgressHUD.show()
    }
    
    func hideLoadingIndicator() {
        ProgressHUD.dismiss()
    }
    
    func showError(message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alertController, animated: true)
    }
    
    func updateRightBarButtonItem(_ item: UIBarButtonItem?) {
        navigationItem.rightBarButtonItem = item
    }
    
    func setupNavigationItem() {
        title = "Избранные NFT"
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func setBackgroundView(message: String?) {
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.font = .bold17
        messageLabel.textColor = .segmentActive
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundView = message == nil ? nil : messageLabel
        
        if message != nil {
            NSLayoutConstraint.activate([
                messageLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
                messageLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
            ])
        }
    }
    
}

