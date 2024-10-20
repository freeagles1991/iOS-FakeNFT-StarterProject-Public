//
//  UserProfileRequest.swift
//  FakeNFT
//
//  Created by Артур  Арсланов on 21.10.2024.
//

import Foundation

struct UserProfileRequest: NetworkRequest {
    var dto: Dto?
    
    var endpoint: URL? {
        return URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    
    var httpMethod: HttpMethod {
        return .get
    }
    
}

