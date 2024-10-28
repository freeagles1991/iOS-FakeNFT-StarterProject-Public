import Foundation
import UIKit

final class CartStore {
    private static let cartKey = "nftsInCart"
    static let cartChangedNotification = Notification.Name("CartStoreCartChanged")

    static var nftsInCart: Set<String> {
        get {
            guard let data = UserDefaults.standard.data(forKey: cartKey),
                  let nftIDs = try? JSONDecoder().decode([String].self, from: data) else {
                return []
            }
            return Set(nftIDs)
        }
        set {
            let nftArray = Array(newValue)
            if let data = try? JSONEncoder().encode(nftArray) {
                UserDefaults.standard.set(data, forKey: cartKey)
            }
            
            NotificationCenter.default.post(name: CartStore.cartChangedNotification, object: nil)
        }
    }
}
