//
//  MyNFTsViewController.swift
//  FakeNFT
//
//  Created by Артур  Арсланов on 13.10.2024.
//

import UIKit
import ProgressHUD

final class MyNFTsViewController: UIViewController {
    private let tableView = UITableView()
    private var presenter: MyNFTsPresenterProtocol
    
    //MARK: - Init
    init(presenter: MyNFTsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    //MARK: - Public Method
    func setPresenter(_ presenter: MyNFTsPresenterProtocol) {
        self.presenter = presenter
    }
    
    //MARK: - Private Method
    @objc private func didTapSortButton() {
        presenter.showSortingAlert()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
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

}

//MARK: - UITableViewDataSource
extension MyNFTsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfNFTs
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NFTTableViewCell.identifier, for: indexPath) as? NFTTableViewCell else {
            return UITableViewCell()
        }
        
        if let nft = presenter.nft(at: indexPath.row) {
            let isLiked = presenter.isLikedNFT(nft.id)
            cell.configure(with: nft, isLiked: isLiked)
        }
        
        cell.delegate = self
        
        return cell
    }
}


extension MyNFTsViewController: NFTTableViewCellDelegate {
    func didTapLikeButton(in cell: NFTTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter.didTapLikeButton(at: indexPath)
    }
    
    
}

//MARK: - MyNFTsViewProtocol
extension MyNFTsViewController: MyNFTsViewProtocol {
    func updateCell(cellIndexPath: IndexPath) {
        tableView.reloadRows(at: [cellIndexPath], with: .automatic)
    }

    
    func showAlert(with viewModel: AlertViewModel) {
        let alertController = viewModel.createAlertController()
        present(alertController, animated: true)
    }
    
    func updateRightBarButtonItem(_ item: UIBarButtonItem?) {
        navigationItem.rightBarButtonItem = item
    }
    
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
        tableView.reloadData()
    }
    
    func setupNavigationItem() {
        title = "Мой NFT"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "filterButtonIcon"),
            style: .plain,
            target: self,
            action: #selector(didTapSortButton)
        )
        navigationItem.rightBarButtonItem?.tintColor = .segmentActive
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
    
}


