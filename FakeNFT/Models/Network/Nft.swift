import Foundation

struct Nft: Decodable {
    let id: String
    let images: [URL]
    let name: String
    let cost: Double
    let rating: Double
    
    // Инициализатор с дефолтными значениями
    init(id: String = "", images: [URL] = [], name: String = "April", cost: Double = 1.78, rating: Double = 80.0) {
        self.id = id
        self.images = images
        self.name = name
        self.cost = cost
        self.rating = rating
    }
}
