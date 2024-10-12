//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Артур  Арсланов on 11.10.2024.
//

import Foundation
import UIKit

final class ProfileViewController: UIViewController {
    
    private var presenter: ProfilePresenterProtocol?
    private let profileView = ProfileView()
    
    init(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigation()
        presenter?.loadProfileData()
    }
    
    @objc
    private func editButtonPressed() {
        print("Show edit")
    }
    
    private func setupUI() {
        view.addSubview(profileView)
        profileView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: view.topAnchor),
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigation() {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 25 ,weight: .bold)
        let pencilImage = UIImage(systemName: "square.and.pencil", withConfiguration: largeConfig)
        
        let editButton = UIBarButtonItem(
            image: pencilImage,
            style: .plain,
            target: self,
            action: #selector(editButtonPressed)
        )
        
        editButton.tintColor = .segmentActive
        navigationItem.rightBarButtonItem = editButton
    }
    
}

extension ProfileViewController: ProfileViewProtocol {
    func displayProfileData(_ profile: Profile) {
        profileView.update(with: profile)
    }
    
}
