import ProgressHUD
import UIKit

protocol LoadingView {
    var activityIndicator: UIActivityIndicatorView { get }
    func showLoading()
    func hideLoading()
}

extension LoadingView {
    func showLoading() {
        ProgressHUD.show()
    }

    func hideLoading() {
        ProgressHUD.dismiss()
    }
}
