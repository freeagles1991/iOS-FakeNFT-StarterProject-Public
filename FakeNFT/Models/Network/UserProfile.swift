import Foundation

struct UserProfile: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts, likes: [String]
    let id: String
}

extension UserProfile: Dto {
    func asDictionary() -> [String: String] {
        return [
            "name": name,
            "description": description,
            "website": website,
            "avatar": avatar,
        ]
    }
}
