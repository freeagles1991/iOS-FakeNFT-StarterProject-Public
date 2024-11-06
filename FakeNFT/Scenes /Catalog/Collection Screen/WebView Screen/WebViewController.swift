//  Created by Artem Morozov on 17.10.2024.


import UIKit
import WebKit

protocol WebViewControllerProtocol: AnyObject {
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

final class WebViewController: UIViewController, WKNavigationDelegate, WebViewControllerProtocol {
    
    private lazy var backButton = UIButton()
    private lazy var webView = WKWebView()
    private lazy var progressView = UIProgressView()
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    private let presenter: WebViewPresenter
    
    // MARK: - Init
    
    init(presenter: WebViewPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        presenter.viewDidLoad()
        estimatedProgressObservation = webView.observe(\.estimatedProgress, changeHandler: { [weak self] _, _ in
            guard let self = self else {
                return
            }
            presenter.didUpdateProgressValue(webView.estimatedProgress)
        })
    }
    
    deinit {
        estimatedProgressObservation?.invalidate()
    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
}

// MARK: - ConfigureUI

private extension WebViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        configureBackButton()
        configureProgressView()
        configureWebView()
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
    
    func configureProgressView() {
        progressView.progressTintColor = .yaBlueUniversal
        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
        ])
    }
    
    func configureWebView() {
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 0),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}
