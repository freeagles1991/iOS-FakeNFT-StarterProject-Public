//
//  FavouritesNFTsPresenter.swift
//  FakeNFT
//
//  Created by Артур  Арсланов on 23.10.2024.
//

import UIKit

protocol FavouritesViewProtocol: AnyObject {
    func setBackgroundView(message: String?)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showError(message: String)
    func reloadData()
    var collectionView: UICollectionView { get }
}

protocol FavouritesPresenterProtocol {
    func viewDidLoad()
    var numberOfNFTs: Int { get }
    func nft(at index: Int) -> Nft?
}

final class FavouritesNFTsPresenter: FavouritesPresenterProtocol {
    weak var view: FavouritesViewProtocol?
    private let servicesAssembly: ServicesAssembly
    private var profile: UserProfile
    private var nftsLikes: [Nft] = []
    
    // MARK: - Init
    init(view: FavouritesViewProtocol?, servicesAssembly: ServicesAssembly, profile: UserProfile) {
        self.view = view
        self.servicesAssembly = servicesAssembly
        self.profile = profile
    }
    
    func viewDidLoad() {
        loadNFTsLikes()
    }
    
    func didTapLikeButton(at indexPath: IndexPath) {
        guard indexPath.row < nftsLikes.count else { return }
        
        let nft = nftsLikes[indexPath.row]
        let isLiked = profile.likes.contains(nft.id)
        updateLikes(isLiked: isLiked, nftID: nft.id, at: indexPath)
    }

    private func updateLikes(isLiked: Bool, nftID: String, at indexPath: IndexPath) {
        var newLikes = profile.likes

        if isLiked {
            newLikes.removeAll(where: { $0 == nftID })
        } else {
            newLikes.append(nftID)
        }

        let resultString = newLikes.isEmpty ? "null" : newLikes.joined(separator: ", ")
        
        servicesAssembly.userProfileService.changeLike(newNftLikes: resultString) { [weak self] result in
            DispatchQueue.main.async {
                self?.handleLikeChangeResult(result, isLiked: isLiked, at: indexPath)
            }
        }
    }

    private func handleLikeChangeResult(_ result: Result<UserProfile, Error>, isLiked: Bool, at indexPath: IndexPath) {
        switch result {
        case .success(let userProfile):
            self.profile = userProfile
            if isLiked {
                self.nftsLikes.remove(at: indexPath.row)
                handleNFTRemoval(at: indexPath)
            }
        case .failure(let error):
            self.view?.showError(message: "Не удалось изменить лайки: \(error.localizedDescription)")
        }
    }
    
    private func handleNFTRemoval(at indexPath: IndexPath) {
        view?.collectionView.performBatchUpdates({
            view?.collectionView.deleteItems(at: [indexPath])
        }, completion: { [weak self] _ in
            if self?.nftsLikes.isEmpty == true {
                self?.setEmptyStateMessage()
            }
        })
    }

    func isLikedNFT(_ nftID: String) -> Bool {
        return profile.likes.contains(nftID)
    }
    
    private func loadNFTsLikes() {
        let likedNfts = profile.likes
        
        guard !likedNfts.isEmpty else {
            setEmptyStateMessage()
            return
        }
        
        nftsLikes.removeAll()
        view?.showLoadingIndicator()
        
        fetchNFTsLikes(from: likedNfts) { [weak self] in
            self?.handleLoadedNFTs()
        }
    }
    
    private func fetchNFTsLikes(from nftIDs: [String], completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        for nftID in nftIDs {
            dispatchGroup.enter()
            servicesAssembly.nftService.loadNft(id: nftID) { [weak self] result in
                self?.handleNFTLoadResult(result, id: nftID)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main, execute: completion)
    }
    
    private func handleNFTLoadResult(_ result: Result<Nft, Error>, id: String) {
        switch result {
        case .success(let nft):
            nftsLikes.append(nft)
        case .failure:
            view?.showError(message: "Ошибка загрузки NFT с ID \(id).")
        }
    }
    
    private func handleLoadedNFTs() {
        view?.hideLoadingIndicator()
        if nftsLikes.isEmpty {
            setEmptyStateMessage()
        } else {
            view?.setBackgroundView(message: nil)
            view?.reloadData()
        }
    }

    private func setEmptyStateMessage() {
        view?.setBackgroundView(message: "У Вас ещё нет избранных NFT")
    }
    
    // MARK: - NFT Access
    var numberOfNFTs: Int {
        return nftsLikes.count
    }
    
    func nft(at index: Int) -> Nft? {
        return index < nftsLikes.count ? nftsLikes[index] : nil
    }
}

