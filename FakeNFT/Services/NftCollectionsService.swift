//  Created by Artem Morozov on 21.10.2024.


import Foundation

typealias NftCollectionCompletion = (Result<[NftCollection], Error>) -> Void

protocol NftCollectionsService {
    func loadNftCollection(completion: @escaping NftCollectionCompletion)
    func changeLike(newNftLikes: String, completion: @escaping (Result<UserProfile, Error>) -> Void)
}

final class NftCollectionsServiceImpl: NftCollectionsService {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadNftCollection(completion: @escaping NftCollectionCompletion) {
        let request = NftCollectionsRequest()
        networkClient.send(request: request, type: [NftCollection].self) { result in
            switch result {
            case .success(let nftCollection):
                completion(.success(nftCollection))
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
