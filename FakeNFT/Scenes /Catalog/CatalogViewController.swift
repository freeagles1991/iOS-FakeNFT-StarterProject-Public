//  Created by Artem Morozov on 14.10.2024.


import UIKit
import ProgressHUD

protocol CatalogViewControllerProtocol:  AnyObject, ErrorView, LoadingView {
    func updateUI()
}

final class CatalogViewController: UIViewController {
    
    private let presenter: CatalogPresenter
    
    private lazy var sortButton = UIButton(type: .system)
    private lazy var tableView = UITableView()
    var activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Init
    
    init(presenter: CatalogPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        presenter.viewDidLoad()
    }
    
    // MARK: - private functions
    
}

// MARK: - CatalogView protocol func

extension CatalogViewController: CatalogViewControllerProtocol {
    
    func updateUI() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource / UITableViewDelegate func

extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collectionAssembly = CollectionAssembly(servicesAssembler: presenter.getServicesAssembly())
        let collectionViewController = collectionAssembly.build(selectedCollection: presenter.dataSource[indexPath.row])
        let collectionNavigationController = UINavigationController(rootViewController: collectionViewController)
        collectionNavigationController.modalPresentationStyle = .fullScreen
        present(collectionNavigationController, animated: true)
    }
}

extension CatalogViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CatalogTableViewCell.reuseIdentifier, for: indexPath)
        guard let catalogCell = cell as? CatalogTableViewCell else {
            return UITableViewCell()
        }
        catalogCell.selectionStyle = .none
        
        catalogCell.configureCell(catalogCellViewModel: presenter.cellViewModels[indexPath.row])
        return catalogCell
    }
}

// MARK: - ConfigureUI

private extension CatalogViewController {
    func configureUI() {
        configureSortButton()
        configureTableView()
        view.addSubview(activityIndicator)
        activityIndicator.constraintCenters(to: view)
    }
    
    func configureSortButton() {
        sortButton.setImage(UIImage(resource: .filterButtonIcon), for: .normal)
        sortButton.tintColor = UIColor.segmentActive
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        sortButton.addTarget(self, action: #selector(showCollectionSortedAlert), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: sortButton)
        navigationItem.rightBarButtonItem = backBarButtonItem
    }
    
    @objc func showCollectionSortedAlert() {
        let alertViewModel = presenter.createSortAlertViewModel()
        let alertController = alertViewModel.createAlertController()
        present(alertController, animated: true)
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CatalogTableViewCell.self, forCellReuseIdentifier: CatalogTableViewCell.reuseIdentifier)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
        
    }
}
