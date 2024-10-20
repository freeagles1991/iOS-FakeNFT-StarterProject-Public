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
    private var nftService: NftService
        
    init(viewController: UIViewController?, nftService: NftService) {
        self.viewController = viewController
        self.nftService = nftService
    }
    
    func navigateToEditProfile(from view: ProfileViewController, with profile: UserProfile) {
        let editProfileVC = EditProfileViewController(profile: profile, delegate: view)
        viewController?.present(editProfileVC, animated: true)
    }
    
    func navigateToMyNFTs(from view: ProfileViewController, with profile: UserProfile) {
        let myNFTsViewController = MyNFTsViewController(nftService: nftService, profile: profile)
        if let navigationController = viewController?.navigationController {
            navigationController.pushViewController(myNFTsViewController, animated: true)
        } else {
            print("NavigationController is nil")
        }

    }
    
    func navigateToFavoritesNFTs(from view: ProfileViewController) {
        let favoritesNFTsViewController = FavouritesNFTsViewController()
        viewController?.navigationController?.pushViewController(favoritesNFTsViewController, animated: true)
    }
}
