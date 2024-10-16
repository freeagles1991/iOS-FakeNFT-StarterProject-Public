import Foundation

struct NftCollection: Codable {
    let createdAt, name: String
    let cover: String
    let nfts: [String]
    let description, author, id: String
}
