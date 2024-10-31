import Foundation

struct Nft: Codable {
    let createdAt, name: String
    let images: [URL]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let id: String
    
    init(createdAt: String = "", name: String  = "Default", images: [URL] = [], rating: Int = 5, description: String = "", price: Double = 1.99, author: String = "Default", id: String = "1464520d-1659-4055-8a79-4593b9569e48") {
        self.createdAt = createdAt
        self.name = name
        self.images = images
        self.rating = rating
        self.description = description
        self.price = price
        self.author = author
        self.id = id
    }
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
