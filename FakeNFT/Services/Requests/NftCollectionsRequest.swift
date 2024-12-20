//  Created by Artem Morozov on 21.10.2024.


import Foundation

struct NftCollectionsRequest: NetworkRequest {
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections")
    }
    
    var dto: Dto?
}
