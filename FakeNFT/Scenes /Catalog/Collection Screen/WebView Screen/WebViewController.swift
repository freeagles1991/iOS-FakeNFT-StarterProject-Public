//  Created by Artem Morozov on 17.10.2024.


import UIKit
import WebKit

final class WebViewController: UIViewController, WKNavigationDelegate {
    
    private lazy var backButton = UIButton()
    private lazy var webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        if let url = URL(string: "https://practicum.yandex.ru") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

// MARK: - ConfigureUI

private extension WebViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        configureWebView()
        configureBackButton()
    }
    
    func configureBackButton() {
        backButton.setImage(UIImage(named: "backButton"), for: .normal)
        backButton.tintColor = UIColor.segmentActive
        backButton.addTarget(self, action: #selector(backButtonDidTapped), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    @objc func backButtonDidTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func configureWebView() {
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}
