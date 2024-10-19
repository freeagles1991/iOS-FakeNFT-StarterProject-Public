//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Артур  Арсланов on 11.10.2024.
//

import Foundation

protocol ProfileViewProtocol: AnyObject {
    func displayProfileData(_ profile: UserProfile)
}

protocol ProfilePresenterProtocol: AnyObject {
    func loadProfileData()
    func getCurrentProfile() -> UserProfile?
    func updateProfileData(_ updatedProfile: UserProfile)
}


final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewProtocol?
    private var currentProfile: UserProfile?
    
    init(view: ProfileViewProtocol?) {
        self.view = view
    }
    
    func loadProfileData() {
        //MOCK
        let profile = UserProfile(
            name: "Joaquin Phoenix",
            avatar: "https://gravatar.com/avatar/5ecccac69e3d98d59e95a789c07fef55?s=400&d=robohash&r=x",
            description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
            website: "Joaquin Phoenix.com",
            nfts: [],
            likes: [],
            id: "1"
        )
        currentProfile = profile
        view?.displayProfileData(profile)
    }
    
    func updateProfileData(_ updatedProfile: UserProfile) {
        self.currentProfile = updatedProfile
        view?.displayProfileData(updatedProfile)
    }
    
    
    func getCurrentProfile() -> UserProfile? {
        currentProfile
    }
}
