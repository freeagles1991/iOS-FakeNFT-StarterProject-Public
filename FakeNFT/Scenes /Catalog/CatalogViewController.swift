//  Created by Artem Morozov on 14.10.2024.


import UIKit

protocol CatalogView: AnyObject {
    func updateUI()
}

final class CatalogViewController: UIViewController {
    
    private let presenter: CatalogPresenter
    
    private lazy var sortButton = UIButton(type: .system)
    private lazy var tableView = UITableView()
    
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

extension CatalogViewController: CatalogView {
    func updateUI() {
        
    }
}

// MARK: - UITableViewDataSource / UITableViewDelegate func

extension CatalogViewController: UITableViewDelegate {
    
}

extension CatalogViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CatalogTableViewCell.reuseIdentifier, for: indexPath)
        guard let catalogCell = cell as? CatalogTableViewCell else {
            return UITableViewCell()
        }
        
        return catalogCell
    }
}

// MARK: - ConfigureUI

private extension CatalogViewController {
    func configureUI() {
        configureSortButton()
        configureTableView()
    }
    
    func configureSortButton() {
        sortButton.setImage(UIImage(resource: .filterButtonIcon), for: .normal)
        sortButton.tintColor = UIColor.segmentActive
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sortButton)
        
        NSLayoutConstraint.activate([
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            sortButton.heightAnchor.constraint(equalToConstant: 42),
            sortButton.widthAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentMode = .scaleToFill
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CatalogTableViewCell.self, forCellReuseIdentifier: CatalogTableViewCell.reuseIdentifier)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
        
    }
}
