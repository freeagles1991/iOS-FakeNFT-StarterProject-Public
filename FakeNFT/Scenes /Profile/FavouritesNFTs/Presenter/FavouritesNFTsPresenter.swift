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
    func setupNavigationItem()
    func reloadData()
}

protocol FavouritesPresenterProtocol {
    func viewDidLoad()
    func loadNFTsLikes()
    var numberOfNFTs: Int { get }
    func nft(at index: Int) -> Nft?
}

final class FavouritesNFTsPresenter: FavouritesPresenterProtocol {
    weak var view: FavouritesViewProtocol?
    private let nftService: NftService
    private let profile: UserProfile
    private var nftsLikes: [Nft] = []
    
    // MARK: - Init
    init(view: FavouritesViewProtocol, nftService: NftService, profile: UserProfile) {
        self.view = view
        self.nftService = nftService
        self.profile = profile
    }
    
    func viewDidLoad() {
        loadNFTsLikes()
    }
    
    func loadNFTsLikes() {
        let likedNfts = profile.nfts.filter {profile.likes.contains($0) }
        
        guard !likedNfts.isEmpty else {
            view?.setBackgroundView(message: "У Вас ещё нет избранных NFT")
            return
        }
        
        view?.showLoadingIndicator()
        fetchNFTsLikes(from: likedNfts) {
            self.handleLoadedNFTs()
        }
    }
    
    private func fetchNFTsLikes(from nftIDs: [String], completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        for nftID in nftIDs {
            dispatchGroup.enter()
            nftService.loadNft(id: nftID) { [weak self] result in
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
            view?.setBackgroundView(message: "У Вас ещё нет избранных NFT")
        } else {
            view?.setBackgroundView(message: nil)
            view?.setupNavigationItem()
            view?.reloadData()
        }
    }
    
    
    // MARK: - NFT Access
    var numberOfNFTs: Int {
        return nftsLikes.count
    }
    
    func nft(at index: Int) -> Nft? {
        return index < nftsLikes.count ? nftsLikes[index] : nil
    }

}
