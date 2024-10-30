//  Created by Artem Morozov on 19.10.2024.

import Foundation


protocol WebViewPresenter: AnyObject {
    var view: WebViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
}


final class WebViewPresenterImpl: WebViewPresenter {
    weak var view: (any WebViewControllerProtocol)?
    
    func viewDidLoad() {
        if let url = URL(string: "https://practicum.yandex.ru") {
            let request = URLRequest(url: url)
            view?.load(request: request)
        } else {
            assertionFailure("URL error")
        }
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}
