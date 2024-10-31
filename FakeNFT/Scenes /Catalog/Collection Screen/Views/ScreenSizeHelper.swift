import Foundation
import UIKit

final class ScreenSizeHelper {
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static let standartWidth: CGFloat = 375.0
    
    static func getViewMultiplier() -> CGFloat {
        return screenWidth / standartWidth
    }
}
