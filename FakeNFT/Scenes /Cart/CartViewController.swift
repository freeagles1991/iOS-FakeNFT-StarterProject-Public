//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Дима on 11.10.2024.
//

import Foundation
import UIKit

protocol CartView: UIViewController {
    
}

final class CartViewController: UIViewController, CartView {
    let presenter: CartPresenter

    init(presenter: CartPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavigationBar() {
        // Filter button
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle.fill"), style: .plain, target: self, action: #selector(filterButtonTapped))
        navigationItem.rightBarButtonItem = filterButton
    }

    @objc private func filterButtonTapped() {
        // Handle edit button action
    }
}
