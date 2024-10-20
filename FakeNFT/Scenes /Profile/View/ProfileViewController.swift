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
    var router: ProfileRouterProtocol?
    
    init(presenter: ProfilePresenterProtocol, router: ProfileRouterProtocol) {
        self.presenter = presenter
        self.router = router
        super.init(nibName: nil, bundle: nil)
    
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        profileView.delegate = self
        setupUI()
        setupNavigation()
        presenter?.loadProfileData()
    }
    
    @objc
    private func editButtonPressed() {
        guard let profile = presenter?.getCurrentProfile() else { return }
        router?.navigateToEditProfile(from: self, with: profile)
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
        let pencilImage = UIImage(systemName: "square.and.pencil", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .bold))
        let editButton = UIBarButtonItem(image: pencilImage, style: .plain, target: self, action: #selector(editButtonPressed))
        editButton.tintColor = .segmentActive
        navigationItem.rightBarButtonItem = editButton
        
        let backImageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .semibold)
        let backImage = UIImage(systemName: "chevron.backward", withConfiguration: backImageConfig)
        
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .segmentActive
    }

    
}

extension ProfileViewController: ProfileViewProtocol {
    func displayProfileData(_ profile: UserProfile) {
        profileView.update(with: profile)
    }
    
}

extension ProfileViewController: EditProfileDelegate {
    func didUpdateProfile(_ updatedProfile: UserProfile) {
        presenter?.updateProfileData(updatedProfile)
        profileView.update(with: updatedProfile)
    }
}

extension ProfileViewController: ProfileViewDelegate {
    func didSelectItem(at index: Int) {
        switch index {
        case 0:
            guard let profile = presenter?.getCurrentProfile() else { return }
            router?.navigateToMyNFTs(from: self, with: profile)
        case 1:
            router?.navigateToFavoritesNFTs(from: self)
        case 2:
            print("Webview")
        default:
            break
        }
    }
}
