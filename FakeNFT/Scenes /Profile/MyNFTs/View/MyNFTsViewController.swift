//
//  MyNFTsViewController.swift
//  FakeNFT
//
//  Created by Артур  Арсланов on 13.10.2024.
//

import UIKit

final class MyNFTsViewController: UIViewController {
    enum SortCriterion {
        case price
        case name
        case rating
    }
    
    private var nfts: [Nft] = []
    private let tableView = UITableView()
    private let nftService: NftService?
    private let profile: UserProfile
    
    init(nftService: NftService?, profile: UserProfile) {
        self.nftService = nftService
        self.profile = profile
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNFTs()
        setupUI()
    }
    
    private func fetchNFTs() {
        guard let nftService = nftService else {
            print("nftService равен nil")
            return
        }
        
        guard !profile.nfts.isEmpty else {
            self.tableView.setBackgroundView(message: "У вас еще нет NFT.")
            return
        }
        
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
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            if self.nfts.isEmpty {
                self.tableView.setBackgroundView(message: "У вас еще нет NFT.")
                self.navigationItem.rightBarButtonItem = nil
            } else {
                self.tableView.setBackgroundView(message: nil)
                self.setupNavigationItem()
            }
            self.tableView.reloadData()
            print("Всего загружено NFT: \(self.nfts.count)")
        }
    }



    
    private func sortNFTs(by criterion: SortCriterion) {
        switch criterion {
        case .price:
            nfts.sort { $0.price < $1.price }
        case .name:
            nfts.sort { $0.name < $1.name }
        case .rating:
            nfts.sort { $0.rating > $1.rating }
        }
        tableView.reloadData()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NFTTableViewCell.self, forCellReuseIdentifier: NFTTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationItem() {
        title = "Мой NFT"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal.decrease"),
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped)
        )
    }
    
    @objc private func sortButtonTapped() {
        let alertController = UIAlertController(title: "Сортировка", message: "Выберите способ сортировки", preferredStyle: .actionSheet)
        
        let sortOptions: [(title: String, type: SortCriterion)] = [
            ("По цене", .price),
            ("По названию", .name),
            ("По рейтингу", .rating)
        ]
        
        for option in sortOptions {
            alertController.addAction(createSortAction(title: option.title, sortType: option.type))
        }
        
        alertController.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        
        present(alertController, animated: true)
    }

    private func createSortAction(title: String, sortType: SortCriterion) -> UIAlertAction {
        return UIAlertAction(title: title, style: .default) { [weak self] _ in
            self?.sortNFTs(by: sortType)
        }
    }

}


extension MyNFTsViewController: UITableViewDelegate {
    
}

extension MyNFTsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nfts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NFTTableViewCell.identifier, for: indexPath) as? NFTTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    
}

extension UITableView {
    func setBackgroundView(message: String?) {
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.font = .bold17
        messageLabel.textColor = .segmentActive
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView = messageLabel
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
