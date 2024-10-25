//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Артур  Арсланов on 11.10.2024.
//

import Foundation
import UIKit

final class ProfileViewController: UIViewController {
    
    private var presenter: ProfilePresenterProtocol
    private let profileView = ProfileView()
    var router: ProfileRouterProtocol
    
    // MARK: - Init
    init(presenter: ProfilePresenterProtocol, router: ProfileRouterProtocol) {
        self.presenter = presenter
        self.router = router
        super.init(nibName: nil, bundle: nil)
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupNavigationBar()
        presenter.loadProfileData()
    }
    
    // MARK: - Private Methods
    private func configureView() {
        profileView.delegate = self
        view.addSubview(profileView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        profileView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: view.topAnchor),
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = createEditButton()
        configureBackButton()
    }
    
    private func createEditButton() -> UIBarButtonItem {
        let pencilImage = UIImage(systemName: "square.and.pencil", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .bold))
        let editButton = UIBarButtonItem(image: pencilImage, style: .plain, target: self, action: #selector(editButtonPressed))
        editButton.tintColor = .segmentActive
        return editButton
    }
    
    private func configureBackButton() {
        let backImageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .semibold)
        let backImage = UIImage(systemName: "chevron.backward", withConfiguration: backImageConfig)
        
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .segmentActive
    }
    
    @objc
    private func editButtonPressed() {
        guard let profile = presenter.getCurrentProfile() else { return }
        router.navigateToEditProfile(from: self, with: profile)
    }
    
}

//MARK: - ProfileViewProtocol
extension ProfileViewController: ProfileViewProtocol {
    func displayProfileData(_ profile: UserProfile) {
        profileView.update(with: profile)
    }
    
}

// MARK: - EditProfileDelegate
extension ProfileViewController: EditProfileDelegate {
    func didUpdateProfile(_ updatedProfile: UserProfile) {
        presenter.updateProfileData(updatedProfile)
        profileView.update(with: updatedProfile)
    }
}

// MARK: - ProfileViewDelegate
extension ProfileViewController: ProfileViewDelegate {
    func didSelectItem(at index: Int) {
        guard let profile = presenter.getCurrentProfile() else { return }
        switch index {
        case 0:
            router.navigateToMyNFTs(from: self, with: profile)
        case 1:
            router.navigateToFavoritesNFTs(from: self, with: profile)
        case 2:
            print("Webview")
        default:
            break
        }
    }
}
