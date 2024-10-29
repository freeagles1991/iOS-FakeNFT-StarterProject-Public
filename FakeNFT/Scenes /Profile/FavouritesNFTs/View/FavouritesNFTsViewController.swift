//
//  FavouritesNFTsViewController.swift
//  FakeNFT
//
//  Created by Артур  Арсланов on 13.10.2024.
//

import UIKit
import ProgressHUD

struct GeometricParams {
    let cellCount: Int
    let leftInset: CGFloat
    let rightInset: CGFloat
    let cellSpacing: CGFloat
    let paddingWidth: CGFloat
    
    init(cellCount: Int, leftInset: CGFloat, rightInset: CGFloat, cellSpacing: CGFloat) {
        self.cellCount = cellCount
        self.leftInset = leftInset
        self.rightInset = rightInset
        self.cellSpacing = cellSpacing
        self.paddingWidth = leftInset + rightInset + CGFloat(cellCount - 1) * cellSpacing
    }
}

final class FavouritesNFTsViewController: UIViewController {
    private var presenter : FavouritesNFTsPresenter
    private var params = GeometricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 8)
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    init(presenter: FavouritesNFTsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidLoad()
    }
    
    private  func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Избранные NFT"
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.register(NFTCollectionViewCell.self, forCellWithReuseIdentifier: NFTCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

//MARK: - UICollectionViewDataSource
extension FavouritesNFTsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("presenter.numberOfNFTs: \(presenter.numberOfNFTs)")
        return presenter.numberOfNFTs
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTCollectionViewCell.identifier, for: indexPath) as? NFTCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let nft = presenter.nft(at: indexPath.row) {
            let isLiked = presenter.isLikedNFT(nft.id)
            cell.configure(with: nft, isLiked: isLiked)
        }
        
        cell.delegate = self
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavouritesNFTsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth =  availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: params.leftInset, bottom: 0, right: params.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        params.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

//MARK: - NFTCollectionViewCellDelegate
extension FavouritesNFTsViewController: NFTCollectionViewCellDelegate {
    func didTapLikeButton(in cell: NFTCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        presenter.didTapLikeButton(at: indexPath)
    }
}

//MARK: - FavouritesViewProtocol
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
            title = nil
            NSLayoutConstraint.activate([
                messageLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
                messageLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
            ])
        }
    }
    
}

