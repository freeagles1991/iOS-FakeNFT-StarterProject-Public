//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Артур  Арсланов on 11.10.2024.
//
import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        if #available(iOS 18.0, *) {
            ProgressHUD.animate(.bouncy) {
                
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}


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
    private let userProfileService: UserProfileServiceProtocol
    
    init(view: ProfileViewProtocol?, userProfileService: UserProfileServiceProtocol) {
        self.view = view
        self.userProfileService = userProfileService
    }
    
    func loadProfileData() {
        UIBlockingProgressHUD.show()
        userProfileService.fetchUserProfile { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.currentProfile = profile
                self.view?.displayProfileData(profile)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print("Ошибка при получении профиля: \(error)")
            }
        }
        
    }
    
    func updateProfileData(_ updatedProfile: UserProfile) {
        self.currentProfile = updatedProfile
        view?.displayProfileData(updatedProfile)
    }
    
    
    func getCurrentProfile() -> UserProfile? {
        currentProfile
    }
}
