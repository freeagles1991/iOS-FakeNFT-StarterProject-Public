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
    func updateAvatarURL(_ url: String)
}

final class EditProfilePresenter: EditProfilePresenterProtocol {
    private weak var view: EditProfileViewProtocol?
    private var profile: UserProfile
    private let userProfileService: UserProfileServiceProtocol
    
    init(view: EditProfileViewProtocol, profile: UserProfile, userProfileService: UserProfileServiceProtocol) {
        self.view = view
        self.profile = profile
        self.userProfileService = userProfileService
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
        
        userProfileService.updateUserProfile(updatedProfile) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                print("Профиль успешно обновлен.")
                self.profile = updatedProfile
                self.view?.didUpdateProfile(updatedProfile)
            case .failure(let error):
                print("Ошибка обновления профиля: \(error.localizedDescription)")
                self.view?.showProfile(self.profile)
            }
        }
    }
    
    func updateAvatarURL(_ url: String) {
        let updatedProfile = UserProfile(
            name: profile.name,
            avatar: url,
            description: profile.description,
            website: profile.website,
            nfts: profile.nfts,
            likes: profile.likes,
            id: profile.id
        )
        
        userProfileService.updateUserProfile(updatedProfile) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.profile = updatedProfile
                self.view?.didUpdateProfile(updatedProfile)
                self.view?.showProfile(updatedProfile)
            case .failure(let error):
                print("Ошибка обновления профиля: \(error.localizedDescription)")
            }
        }
    }
}
