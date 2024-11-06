//
//  UpdateUserProfileRequest.swift
//  FakeNFT
//
//  Created by Артур  Арсланов on 29.10.2024.
//

import Foundation

struct UpdateUserProfileRequest: NetworkRequest {
    var dto: Dto?
    
    var endpoint: URL? {
        return URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    
    var httpMethod: HttpMethod = .put
}

struct UpdateProfileDto: Dto {
    let name: String
    let description: String
    let website: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case website
    }
    
    func asDictionary() -> [String : String] {
        [
            CodingKeys.name.rawValue: name,
            CodingKeys.description.rawValue: description,
            CodingKeys.website.rawValue: website
        ]
    }
}
