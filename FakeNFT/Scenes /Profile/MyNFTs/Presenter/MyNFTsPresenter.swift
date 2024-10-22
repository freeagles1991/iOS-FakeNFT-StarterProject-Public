//
//  MyNFTsPresenter.swift
//  FakeNFT
//
//  Created by Артур  Арсланов on 21.10.2024.
//

import Foundation

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
    func sortNFTs(by criterion: MyNFTsViewController.SortCriterion)
    var numberOfNFTs: Int { get }
    func nft(at index: Int) -> Nft?
    func handleSortSelection()
}

final class MyNFTsPresenter: MyNFTsPresenterProtocol {
    weak var view: MyNFTsViewProtocol?
    private let nftService: NftService
    private let profile: UserProfile
    private var nfts: [Nft] = []
    
    init(view: MyNFTsViewProtocol, nftService: NftService, profile: UserProfile) {
        self.view = view
        self.nftService = nftService
        self.profile = profile
    }
    
    func viewDidLoad() {
        loadNFTs()
    }
    
    func loadNFTs() {
        guard !profile.nfts.isEmpty else {
            view?.setBackgroundView(message: "У вас еще нет NFT.")
            return
        }
        
        view?.showLoadingIndicator()
        let dispatchGroup = DispatchGroup()
        for nftID in profile.nfts {
            dispatchGroup.enter()
            nftService.loadNft(id: nftID) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let nft):
                    self.nfts.append(nft)
                    print("Загружено NFT: \(nft)")
                case .failure(let error):
                    print("Ошибка загрузки NFT с ID \(nftID): \(error)")
                    self.view?.showError(message: "Ошибка загрузки NFT с ID \(nftID).")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.view?.hideLoadingIndicator() 
            
            if self.nfts.isEmpty {
                self.view?.setBackgroundView(message: "У вас еще нет NFT.")
                self.view?.updateRightBarButtonItem(nil)
            } else {
                self.view?.setBackgroundView(message: nil)
                self.view?.setupNavigationItem()
            }
            self.view?.reloadData()
            print("Всего загружено NFT: \(self.nfts.count)")
        }
    }
    
    func handleSortSelection() {
        let sortOptions: [(title: String, type: MyNFTsViewController.SortCriterion)] = [
            ("По цене", .price),
            ("По названию", .name),
            ("По рейтингу", .rating)
        ]
        
        let alertActions = sortOptions.map { option in
            AlertViewModel.AlertAction(title: option.title, style: .default) { [weak self] in
                self?.sortNFTs(by: option.type)
                self?.view?.reloadData()
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
    
    func sortNFTs(by criterion: MyNFTsViewController.SortCriterion) {
        switch criterion {
        case .price:
            nfts.sort { $0.price < $1.price }
        case .name:
            nfts.sort { $0.name < $1.name }
        case .rating:
            nfts.sort { $0.rating > $1.rating }
        }
        view?.reloadData()
    }
    
    var numberOfNFTs: Int {
        return nfts.count
    }
    
    func nft(at index: Int) -> Nft? {
        guard index < nfts.count else { return nil }
        return nfts[index]
    }
}
