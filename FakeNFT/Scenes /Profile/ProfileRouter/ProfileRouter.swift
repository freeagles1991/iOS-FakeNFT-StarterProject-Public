//
//  ProfileRouter.swift
//  FakeNFT
//
//  Created by Артур  Арсланов on 19.10.2024.
//

import UIKit

protocol ProfileRouterProtocol: AnyObject {
    func navigateToEditProfile(from view: ProfileViewController, with profile: UserProfile)
    func navigateToMyNFTs(from view: ProfileViewController, with profile: UserProfile)
    func navigateToFavoritesNFTs(from view: ProfileViewController)
}

final class ProfileRouter: ProfileRouterProtocol {
    
    weak var viewController: UIViewController?
    private var assemblyBuilder: AssemblyBuilderProfile
    private var nftService: NftService
        
    init(viewController: UIViewController?, nftService: NftService, assemblyBuilder: AssemblyBuilderProfile) {
        self.viewController = viewController
        self.nftService = nftService
        self.assemblyBuilder = assemblyBuilder
    }
    
    func navigateToEditProfile(from view: ProfileViewController, with profile: UserProfile) {
        let editProfileVC = EditProfileViewController(profile: profile, delegate: view)
        viewController?.present(editProfileVC, animated: true)
    }
    
    func navigateToMyNFTs(from view: ProfileViewController, with profile: UserProfile) {
        let myNFTsViewController = assemblyBuilder.createMyNFTsModule(from: view, with: profile)
        if let navigationController = view.navigationController {
            navigationController.pushViewController(myNFTsViewController, animated: true)
        }
    }

    
    func navigateToFavoritesNFTs(from view: ProfileViewController) {
        let favoritesNFTsViewController = FavouritesNFTsViewController(presenter: nil)
        viewController?.navigationController?.pushViewController(favoritesNFTsViewController, animated: true)
    }
}
