//
//  EditProfilePresenter.swift
//  FakeNFT
//
//  Created by Артур  Арсланов on 19.10.2024.
//

import Foundation

protocol EditProfilePresenterProtocol: AnyObject {
    func loadProfileData()
    func saveProfileData(name: String, description: String, website: String)
}

final class EditProfilePresenter: EditProfilePresenterProtocol {
    
    private weak var view: EditProfileViewProtocol?
    private var profile: UserProfile
    
    init(view: EditProfileViewProtocol, profile: UserProfile) {
        self.view = view
        self.profile = profile
    }
    
    func loadProfileData() {
        view?.showProfile(profile)
    }
    
    func saveProfileData(name: String, description: String, website: String) {
        let updatedProfile = UserProfile(
            name: name.isEmpty ? profile.name : name,
            avatar: profile.avatar,
            description: description.isEmpty ? profile.description : description,
            website: website.isEmpty ? profile.website : website,
            nfts: profile.nfts,
            likes: profile.likes,
            id: profile.id
        )
        
        view?.didUpdateProfile(updatedProfile)
    }
}
