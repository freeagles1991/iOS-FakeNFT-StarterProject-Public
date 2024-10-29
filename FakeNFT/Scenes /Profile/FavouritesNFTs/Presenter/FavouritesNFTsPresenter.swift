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
        var newLikes = profile.likes

        if isLiked {
            newLikes.removeAll(where: { $0 == nft.id })
            nftsLikes.remove(at: indexPath.row)
            print("Удаляем NFT, новое nftsLikes.count: \(nftsLikes.count)")
        } else {
            newLikes.append(nft.id)
        }

        let resultString: String = newLikes.isEmpty ? "null" : newLikes.joined(separator: ", ")
        print("Отправляемые лайки: \(resultString)")

        servicesAssembly.userProfileService.changeLike(newNftLikes: resultString) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userProfile):
                    self?.profile = userProfile
                    self?.loadNFTsLikes()
                    self?.view?.reloadData()
                    print("Лайк изменен, новое nftsLikes.count: \(self?.nftsLikes.count ?? 0)")
                case .failure(let error):
                    self?.view?.showError(message: "Не удалось изменить лайки")
                    print("Ошибка при изменении лайка: \(error.localizedDescription)")
                }
            }
        }
    }


    func isLikedNFT(_ nftID: String) -> Bool {
        return profile.likes.contains(nftID)
    }
    
    private func loadNFTsLikes() {
        let likedNfts = profile.likes
        
        guard !likedNfts.isEmpty else {
            view?.setBackgroundView(message: "У Вас ещё нет избранных NFT")
            return
        }
        
        nftsLikes.removeAll()
        view?.showLoadingIndicator()
        
        fetchNFTsLikes(from: likedNfts) {
            self.handleLoadedNFTs()
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
            view?.setBackgroundView(message: "У Вас ещё нет избранных NFT")
        } else {
            view?.setBackgroundView(message: nil)
            view?.reloadData()
            print("presenter.numberOfNFTs: \(self.numberOfNFTs)")
        }
    }
    
    // MARK: - NFT Access
    var numberOfNFTs: Int {
        print(#function, nftsLikes.count)
        return nftsLikes.count
    }
    
    func nft(at index: Int) -> Nft? {
        return index < nftsLikes.count ? nftsLikes[index] : nil
    }
    
}
