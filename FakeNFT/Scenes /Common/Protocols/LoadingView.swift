import ProgressHUD
import UIKit

protocol LoadingView {
    var activityIndicator: UIActivityIndicatorView { get }
    var window: UIWindow? { get }
    func showLoading()
    func hideLoading()
}

extension LoadingView {
    func showLoading() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }

    func hideLoading() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
