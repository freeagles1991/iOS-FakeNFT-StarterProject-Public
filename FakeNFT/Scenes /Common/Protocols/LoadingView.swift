import ProgressHUD
import UIKit

protocol LoadingView {
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
