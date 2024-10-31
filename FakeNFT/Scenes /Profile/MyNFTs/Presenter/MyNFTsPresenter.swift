//
//  MyNFTsPresenter.swift
//  FakeNFT
//
//  Created by Артур  Арсланов on 21.10.2024.
//

import Foundation
import UIKit

protocol MyNFTsViewProtocol: AnyObject {
    func setBackgroundView(message: String?)
    func reloadData()
    func setupNavigationItem()
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showError(message: String)
    func updateRightBarButtonItem(_ item: UIBarButtonItem?)
    func showAlert(with viewModel: AlertViewModel)
    func updateCell(cellIndexPath: IndexPath)
}

protocol MyNFTsPresenterProtocol {
    func viewDidLoad()
    var numberOfNFTs: Int { get }
    func nft(at index: Int) -> Nft?
    func isLikedNFT(_ nftID: String) -> Bool
    func showSortingAlert()
    func didTapLikeButton(at index: IndexPath)
}

final class MyNFTsPresenter: MyNFTsPresenterProtocol {
    // MARK: - Properties
    weak var view: MyNFTsViewProtocol?
    private let servicesAssembly: ServicesAssembly
    private var profile: UserProfile
    private var nfts: [Nft] = []

    // MARK: - Init
    init(view: MyNFTsViewProtocol?, servicesAssembly: ServicesAssembly, profile: UserProfile) {
        self.view = view
        self.servicesAssembly = servicesAssembly
        self.profile = profile
    }

    // MARK: - Public Methods
    func viewDidLoad() {
        loadNFTs()
    }
    
    func isLikedNFT(_ nftID: String) -> Bool {
        return profile.likes.contains(nftID)
    }
    
    private func handleLoadedNFTs() {
        view?.hideLoadingIndicator()
        if nfts.isEmpty {
            view?.setBackgroundView(message: "У вас еще нет NFT.")
            view?.updateRightBarButtonItem(nil)
        } else {
            applySavedSortOption()
            view?.setBackgroundView(message: nil)
            view?.setupNavigationItem()
            view?.reloadData()
        }
    }
    
    func didTapLikeButton(at index: IndexPath) {
        guard index.row < nfts.count else { return }
        
        let currentNft = nfts[index.row]
        let isLiked = profile.likes.contains(currentNft.id)
        
        let updatedLikes = isLiked ? profile.likes.filter { $0 != currentNft.id } : profile.likes + [currentNft.id]
        let likesString = updatedLikes.isEmpty ? "null" : updatedLikes.joined(separator: ", ")
        
        servicesAssembly.userProfileService.changeLike(newNftLikes: likesString) { [weak self] result in
            DispatchQueue.main.async {
                self?.handleLikeChangeResult(result, for: index)
            }
        }
    }
    
    //MARK: - NFT Access
    var numberOfNFTs: Int {
        return nfts.count
    }

    func nft(at index: Int) -> Nft? {
        return index < nfts.count ? nfts[index] : nil
    }
    
    //MARK: - Private Methods
    //  Loading NFTs
    private func loadNFTs() {
        guard !profile.nfts.isEmpty else {
            view?.setBackgroundView(message: "У вас еще нет NFT.")
            return
        }

        view?.showLoadingIndicator()
        fetchNFTs { [weak self] in
            self?.handleLoadedNFTs()
        }
    }

    private func fetchNFTs(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()

        for nftID in profile.nfts {
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
            nfts.append(nft)
        case .failure:
            view?.showError(message: "Ошибка загрузки NFT с ID \(id).")
        }
    }

    private func handleLikeChangeResult(_ result: Result<UserProfile, Error>, for index: IndexPath) {
        switch result {
        case .success(let updatedProfile):
            profile = updatedProfile
            view?.updateCell(cellIndexPath: index)
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
            view?.showError(message: "Ошибка обновления лайков: \(error.localizedDescription)")
        }
    }

}

// MARK: - SortingDelegate
extension MyNFTsPresenter: SortingDelegate {
    func sortNFTs(by criterion: SortingMethod) {
        nfts.sort { $0.compare(with: $1, by: criterion) }
        view?.reloadData()
    }

    private func applySavedSortOption() {
        let savedCriterion = SortingHelper.savedSortingMethodInCart
        sortNFTs(by: savedCriterion)
    }

    func showSortingAlert() {
        guard let alertViewModel = SortingHelper.makeSortingAlertViewModel(sortingDelegate: self) else { return }
        view?.showAlert(with: alertViewModel)
    }
}



