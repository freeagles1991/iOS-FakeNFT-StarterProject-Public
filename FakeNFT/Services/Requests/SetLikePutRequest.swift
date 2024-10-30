//  Created by Artem Morozov on 28.10.2024.

import Foundation

struct SetLikePutRequest: NetworkRequest {
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    
    var dto: Dto?
    
    var httpMethod: HttpMethod = .put
}

struct ChangeLikeDtoObject: Dto {
    
    let likes: String
    
    enum CodingKeys: String, CodingKey {
        case likes
    }
    
    func asDictionary() -> [String : String] {
        [
            CodingKeys.likes.rawValue: likes
        ]
    }
}
