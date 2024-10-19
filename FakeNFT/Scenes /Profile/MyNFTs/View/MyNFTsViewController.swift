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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNFTs()
        setupUI()
    }
    
    private func fetchNFTs() {
        if nfts.isEmpty {
            tableView.setBackgroundView(message: "У вас еще нет NFT.")
            navigationItem.rightBarButtonItem = nil
        } else {
            tableView.setBackgroundView(message: nil)
            setupNavigationItem()
        }
        tableView.reloadData()
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
        
        alertController.addAction(UIAlertAction(title: "По цене", style: .default, handler: { [weak self] _ in
            self?.sortNFTs(by: .price)
        }))
        
        alertController.addAction(UIAlertAction(title: "По названию", style: .default, handler: { [weak self] _ in
            self?.sortNFTs(by: .name)
        }))
        
        alertController.addAction(UIAlertAction(title: "По рейтингу", style: .default, handler: { [weak self] _ in
            self?.sortNFTs(by: .rating)
        }))
        
        alertController.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        
        present(alertController, animated: true)
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
