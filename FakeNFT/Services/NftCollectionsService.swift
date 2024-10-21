//  Created by Artem Morozov on 21.10.2024.


import Foundation

typealias NftCollectionCompletion = (Result<[NftCollection], Error>) -> Void

protocol NftCollectionsService {
    func loadNftCollection(completion: @escaping NftCollectionCompletion)
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
    
    
}
