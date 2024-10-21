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
    private(set) var presenter: MyNFTsPresenterProtocol?
    
    init(presenter: MyNFTsPresenterProtocol?) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    func setPresenter(_ presenter: MyNFTsPresenterProtocol) {
        self.presenter = presenter
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NFTTableViewCell.self, forCellReuseIdentifier: NFTTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 140
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setBackgroundView(message: String?) {
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.font = .bold17
        messageLabel.textColor = .segmentActive
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.backgroundView = message == nil ? nil : messageLabel
        
        if message != nil {
            NSLayoutConstraint.activate([
                messageLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
                messageLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
            ])
        }
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func setupNavigationItem() {
        title = "Мой NFT"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal.decrease"),
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped)
        )
    }
    
    func showLoadingIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    func hideLoadingIndicator() {
        view.subviews.compactMap { $0 as? UIActivityIndicatorView }.forEach { $0.stopAnimating() }
    }
    
    func showError(message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alertController, animated: true)
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
            self?.presenter?.sortNFTs(by: sortType)
            self?.reloadData()
        }
    }
}

extension MyNFTsViewController: UITableViewDelegate {
    
}

extension MyNFTsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfNFTs ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NFTTableViewCell.identifier, for: indexPath) as? NFTTableViewCell else {
            return UITableViewCell()
        }
        
        if let nft = presenter?.nft(at: indexPath.row) {
            cell.configure(with: nft)
        }
        
        return cell
    }
}

extension MyNFTsViewController: MyNFTsViewProtocol {
    func updateRightBarButtonItem(_ item: UIBarButtonItem?) {
        navigationItem.rightBarButtonItem = item
    }
}


