import Foundation

struct Nft: Codable {
    let createdAt, name: String
    let images: [URL]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let id: String
}

extension Nft {
    func compare(with other: Nft, by criterion: SortingMethod) -> Bool {
        switch criterion {
        case .price:
            return price < other.price
        case .name:
            return name < other.name
        case .rating:
            return rating > other.rating
        }
    }
}
