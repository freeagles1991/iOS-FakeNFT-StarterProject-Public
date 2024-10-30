import Foundation
import UIKit

final class RemoveFromCartAssembly {
    public func build() -> UIViewController {
        let presenter = RemoveFromCartPresenterImpl()
        let viewController = RemoveFromCartViewControllerImpl(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
