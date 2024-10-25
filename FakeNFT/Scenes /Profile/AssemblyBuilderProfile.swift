//
//  AssemblyBuilderProfile.swift
//  FakeNFT
//
//  Created by Артур  Арсланов on 21.10.2024.
//

import UIKit

final class AssemblyBuilderProfile {

    private let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }

    func createProfileModule() -> UIViewController {
        let userProfileService = servicesAssembly.userProfileService
        let nftService = servicesAssembly.nftService

        let presenter = ProfilePresenter(view: nil, userProfileService: userProfileService)
        let router = ProfileRouter(viewController: nil, nftService: nftService, assemblyBuilder: self)

        let profileViewController = ProfileViewController(presenter: presenter, router: router)
        presenter.view = profileViewController
        router.viewController = profileViewController

        return UINavigationController(rootViewController: profileViewController)
    }

    func createMyNFTsModule(from view: ProfileViewController, with profile: UserProfile) -> UIViewController {
        let nftService = servicesAssembly.nftService

        let presenter = MyNFTsPresenter(view: nil, nftService: nftService, profile: profile)
        let myNFTsViewController = MyNFTsViewController(presenter: presenter)
        presenter.view = myNFTsViewController

        return myNFTsViewController
    }
    
    func favouritesNFTsModule(from view: ProfileViewController, with profile: UserProfile) -> UIViewController {
        let nftService = servicesAssembly.nftService
        
        let presenter = FavouritesNFTsPresenter(view: nil, nftService: nftService, profile: profile)
        let favouritesNFTsVC = FavouritesNFTsViewController(presenter: presenter)
        presenter.view = favouritesNFTsVC
        
        return favouritesNFTsVC
    }
}
