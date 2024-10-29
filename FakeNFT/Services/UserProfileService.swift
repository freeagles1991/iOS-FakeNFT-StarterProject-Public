//
//  UserProfileService.swift
//  FakeNFT
//
<<<<<<< HEAD
//  Created by Артур  Арсланов on 21.10.2024.
=======
//  Created by Артур  Арсланов on 27.10.2024.
>>>>>>> develop
//

import Foundation

protocol UserProfileServiceProtocol {
    func fetchUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void)
<<<<<<< HEAD
=======
    func updateUserProfile(_ profile: UserProfile, completion: @escaping (Result<Void, Error>) -> Void)
    func changeLike(newNftLikes: String, completion: @escaping (Result<UserProfile, Error>) -> Void)
>>>>>>> develop
}

final class UserProfileService: UserProfileServiceProtocol {
    private let networkClient: NetworkClient
<<<<<<< HEAD

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

=======
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
>>>>>>> develop
    func fetchUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        let request = UserProfileRequest()
        networkClient.send(request: request) { [weak self] result in
            guard self != nil  else { return }
            switch result {
            case .success(let data):
                do {
                    let profile = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(.success(profile))
                } catch {
                    completion(.failure(NetworkClientError.parsingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
<<<<<<< HEAD
=======
    
    func updateUserProfile(_ profile: UserProfile, completion: @escaping (Result<Void, Error>) -> Void) {
        let request = UpdateUserProfileRequest(dto: profile)
        networkClient.send(request: request) { result in
            switch result {
            case .success:
                completion(.success(()))
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
>>>>>>> develop
}
