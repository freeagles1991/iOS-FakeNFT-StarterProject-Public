//
//  UserProfileService.swift
//  FakeNFT
//
//  Created by Артур  Арсланов on 27.10.2024.
//

import Foundation

protocol UserProfileServiceProtocol {
    func fetchUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void)
    func changeLike(newNftLikes: String, completion: @escaping (Result<UserProfile, Error>) -> Void)
}

final class UserProfileService: UserProfileServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        let request = UserProfileRequest()
        networkClient.send(request: request, type: UserProfile.self) { result in
            switch result {
            case .success(let userProfile):
                completion(.success(userProfile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func changeLike(newNftLikes: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        let dto = ChangeLikeDtoObject(likes: newNftLikes)
        let request = SetLikePutRequest(dto: dto)
        networkClient.send(request: request, type: UserProfile.self) { result in
            switch result {
            case .success(let userProfile):
                completion(.success(userProfile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
