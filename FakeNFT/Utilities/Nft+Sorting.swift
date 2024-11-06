import Foundation

enum SortingMethod: String {
    case price, name, rating
}

extension SortingMethod {
    var displayName: String {
        switch self {
        case .price:
            return NSLocalizedString("SortingMethod_Price", comment: "Sort by price")
        case .name:
            return NSLocalizedString("SortingMethod_Name", comment: "Sort by name")
        case .rating:
            return NSLocalizedString("SortingMethod_Rating", comment: "Sort by rating")
        }
    }
}
