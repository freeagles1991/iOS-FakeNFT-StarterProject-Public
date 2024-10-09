import UIKit

extension UIColor {
    // Creates color from a hex string
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: CGFloat(alpha) / 255
        )
    }

    // Background Colors
    static let background = UIColor.white
    
    //MARK: Day/Night
    private static let yaBlackLight = UIColor(hexString: "#1A1B22")
    private static let yaBlackDark = UIColor(hexString: "#FFFFFF")
    private static let yaWhiteLight = UIColor(hexString: "#FFFFFF")
    private static let yaWhiteDark = UIColor(hexString: "#1A1B22")
    private static let yaLightGrayLight = UIColor(hexString: "#F7F7F8")
    private static let yaLightGrayDark = UIColor(hexString: "#2C2C2E")

    static let segmentActive = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? .yaBlackDark
        : .yaBlackLight
    }

    static let segmentInactive = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? .yaLightGrayDark
        : .yaLightGrayLight
    }

    static let closeButton = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? .yaBlackDark
        : .yaBlackLight
    }
    
    //MARK: Universal
    
    private static let yaGrayUniversal = UIColor(hexString: "#625C5C")
    private static let yaRedUniversal = UIColor(hexString: "#F56B6C")
    private static let yaBackgroundUniversal = UIColor(hexString: "#1A1B2280")
    private static let yaGreenUniversal = UIColor(hexString: "#1C9F00")
    private static let yaBlueUniversal = UIColor(hexString: "#0A84FF")
    private static let yaBlackUniversal = UIColor(hexString: "#1A1B22")
    private static let yaWhiteUniversal = UIColor(hexString: "#FFFFFF")
    private static let yaYellowUniversal = UIColor(hexString: "#FEEF0D")
}
