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
}

protocol MyNFTsPresenterProtocol {
    func viewDidLoad()
    func loadNFTs()
    func sortNFTs(by criterion: SortCriterion)
    var numberOfNFTs: Int { get }
    func nft(at index: Int) -> Nft?
    func handleSortSelection()
}

final class MyNFTsPresenter: MyNFTsPresenterProtocol {

    // MARK: - Properties
    weak var view: MyNFTsViewProtocol?
    private let nftService: NftService
    private let profile: UserProfile
    private var nfts: [Nft] = []
    private let sortKey = "selectedSortCriterion"

    // MARK: - Init
    init(view: MyNFTsViewProtocol, nftService: NftService, profile: UserProfile) {
        self.view = view
        self.nftService = nftService
        self.profile = profile
    }

    // MARK: - Life Cycle
    func viewDidLoad() {
        loadNFTs()
        applySavedSortOption()
    }

    // MARK: - Loading NFTs
    func loadNFTs() {
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
            nfts.append(nft)
        case .failure:
            view?.showError(message: "Ошибка загрузки NFT с ID \(id).")
        }
    }
    
    private func handleLoadedNFTs() {
        view?.hideLoadingIndicator()
        if nfts.isEmpty {
            view?.setBackgroundView(message: "У вас еще нет NFT.")
            view?.updateRightBarButtonItem(nil)
        } else {
            view?.setBackgroundView(message: nil)
            view?.setupNavigationItem()
            view?.reloadData()
        }
    }

    // MARK: - Sorting NFTs
    func handleSortSelection() {
        let sortOptions: [SortCriterion] = [.price, .name, .rating]
        let alertActions = sortOptions.map { criterion in
            AlertViewModel.AlertAction(title: criterion.displayName, style: .default) { [weak self] in
                self?.sortNFTs(by: criterion)
            }
        }
        let cancelAction = AlertViewModel.AlertAction(title: "Отменить", style: .cancel, handler: nil)
        let alertViewModel = AlertViewModel(
            title: "Сортировка",
            message: "Выберите способ сортировки",
            actions: alertActions + [cancelAction],
            preferredStyle: .actionSheet
        )
        view?.showAlert(with: alertViewModel)
    }
    
    func sortNFTs(by criterion: SortCriterion) {
        nfts.sort { $0.compare(with: $1, by: criterion) }
        saveSortOption(criterion)
        view?.reloadData()
    }
    
    // MARK: - Handling Saved Sort Option
    private func saveSortOption(_ criterion: SortCriterion) {
        UserDefaults.standard.set(criterion.rawValue, forKey: sortKey)
    }
    
    private func applySavedSortOption() {
        guard let savedValue = UserDefaults.standard.string(forKey: sortKey),
              let savedCriterion = SortCriterion(rawValue: savedValue) else { return }
        sortNFTs(by: savedCriterion)
    }

    // MARK: - NFT Access
    var numberOfNFTs: Int {
        return nfts.count
    }
    
    func nft(at index: Int) -> Nft? {
        return index < nfts.count ? nfts[index] : nil
    }
}


