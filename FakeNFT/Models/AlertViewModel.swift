//  Created by Artem Morozov on 20.10.2024.


import UIKit

struct AlertViewModel {
    let title: String?
    let message: String?
    let actions: [AlertAction]
    let preferredStyle: UIAlertController.Style

    struct AlertAction {
        let title: String
        let style: UIAlertAction.Style
        let handler: ((() -> Void)?)
    }

    // Создание UIAlertController на основе ViewModel
    func createAlertController() -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)

        for action in actions {
            let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
                action.handler?()
            }
            alertController.addAction(alertAction)
        }

        return alertController
    }
}
