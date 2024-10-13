//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Артур  Арсланов on 11.10.2024.
//

import Foundation

protocol ProfileViewProtocol: AnyObject {
    func displayProfileData(_ profile: Profile)
}

protocol ProfilePresenterProtocol: AnyObject {
    func loadProfileData()
    func getCurrentProfile() -> Profile?
    func updateProfileData(_ updatedProfile: Profile)
}


final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewProtocol?
    private var currentProfile: Profile?
    
    init(view: ProfileViewProtocol?) {
        self.view = view
    }
    
    func loadProfileData() {
        //MOCK
        let profile = Profile(
            name: "Joaquin Phoenix",
            description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
            avatarURL: "https://gravatar.com/avatar/5ecccac69e3d98d59e95a789c07fef55?s=400&d=robohash&r=x",
            website: "Joaquin Phoenix.com"
        )
        self.currentProfile = profile
        view?.displayProfileData(profile)
    }
    
    func updateProfileData(_ updatedProfile: Profile) {
        self.currentProfile = updatedProfile
        view?.displayProfileData(updatedProfile)
    }
    
    
    func getCurrentProfile() -> Profile? {
        return currentProfile
    }
}
